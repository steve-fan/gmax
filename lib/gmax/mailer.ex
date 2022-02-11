defmodule Gmax.Mailer do
  alias Gmax.Account
  alias GoogleApi.Gmail.V1.Model, as: GmailModel
  require Logger

  def send_draft(user) do
    case Gmax.Mail.get_unsend_draft(user.id) do
      nil ->
        {:nomore}

      draft ->
        send_count = Gmax.Mail.send_count_of_last_24hours(user.id)

        # hd 用来表明用户是否是 G Suite 付费用户
        # 付费用户的每天邮件发送额度是 2000，普通用户 500
        # 乘以系数 0.9，每天保留 10% 的额度用来发送日常邮件。
        case user.hd do
          nil ->
            if send_count < 450 do
              do_sent_draft(user, draft)
            else
              {:limit_reached, %{}}
            end

          _ ->
            if send_count < 1800 do
              do_sent_draft(user, draft)
            else
              {:limit_reached, %{}}
            end
        end
    end
  end

  def do_sent_draft(user, draft) do
    [to | left_to] = draft.to

    vars =
      extract_internal_vars(to)
      |> merge_sheet_vars(draft.sheet_values, draft.email_field)

    raw =
      render(draft.message, vars)
      |> replace_to(vars["__to"])
      |> Mail.Message.delete_headers([:date, :received])
      |> Mail.Renderers.RFC2822.render()
      |> Base.url_encode64()

    personal_message = %GmailModel.Message{raw: raw}

    case Gmax.Gmail.gmail_users_messages_send(user, body: personal_message) do
      {:ok, message} ->
        Gmax.Mail.update_draft(draft, %{to: left_to})
        message_attrs = %{msg_id: message.id, thread_id: message.threadId, user_id: user.id}
        Gmax.Mail.create_message(message_attrs)
        {:ok, message}

      {:error, %{status: status, body: body} = env} ->
        body = Jason.decode!(body)
        Logger.error(inspect(body))

        case status do
          429 ->
            {:limit_reached, body}

          430 ->
            {:limit_reached, body}

          _ ->
            {:error, body}
        end
    end
  end

  def replace_to(message, recipients) when is_list(recipients) do
    Mail.Message.put_header(message, "to", recipients)
  end

  def replace_to(message, recipient) do
    replace_to(message, [recipient])
  end

  def render(%Mail.Message{multipart: false} = message, vars) do
    body =
      case message.headers["content-type"] do
        "text/plain" -> Mustachex.render(message.body, vars)
        ["text/plain" | _tail] -> Mustachex.render(message.body, vars)
        "text/html" -> Mustachex.render(message.body, vars)
        ["text/html" | _tail] -> Mustachex.render(message.body, vars)
        _ -> message.body
      end

    %Mail.Message{message | body: body}
  end

  def render(%Mail.Message{multipart: true} = message, vars) do
    parts = message.parts |> Enum.map(fn p -> render(p, vars) end)
    %Mail.Message{message | parts: parts}
  end

  def extract_internal_vars(to) when is_tuple(to) do
    full_name = elem(to, 0)
    decoded_full_name = decode_recipient_name(full_name)

    first_name = String.split(decoded_full_name, " ") |> hd
    last_name = String.split(decoded_full_name, " ") |> List.last()

    %{
      "FirstName" => first_name,
      "LastName" => last_name,
      "FullName" => decoded_full_name,
      "Email" => elem(to, 1),
      "__to" => to
    }
  end

  def extract_internal_vars(to) when is_list(to) do
    [full_name | [email | _]] = to
    decoded_full_name = decode_recipient_name(full_name)
    first_name = String.split(decoded_full_name, " ") |> hd
    last_name = String.split(decoded_full_name, " ") |> List.last()

    %{
      "FirstName" => first_name,
      "LastName" => last_name,
      "FullName" => decoded_full_name,
      "Email" => email,
      "__to" => {full_name, email}
    }
  end

  def extract_internal_vars(to) when is_binary(to) do
    email = String.split(to, ",") |> hd |> String.trim()

    %{
      "FirstName" => nil,
      "FullName" => nil,
      "LastName" => nil,
      "Email" => email,
      "__to" => to
    }
  end

  def merge_sheet_vars(inter_vars, nil, nil) do
    inter_vars
  end

  def merge_sheet_vars(inter_vars, rows, email_field) do
    sheet_vars = Enum.find(rows, %{}, fn row -> row[email_field] == inter_vars["Email"] end)

    Map.merge(inter_vars, sheet_vars)
  end

  def decode_recipient_name(name) do
    case Regex.run(~r/=\?UTF-8\?B\??(.+)\?=/, name) do
      [_ | [encoded_name | _]] ->
        Base.url_decode64!(encoded_name)

      _ ->
        name
    end
  end
end
