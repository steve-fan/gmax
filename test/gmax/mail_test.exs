defmodule Gmax.MailTest do
  use Gmax.DataCase

  alias Gmax.Mail, as: GmaxMail

  describe "drafts" do
    alias Gmax.Mail.Draft

    @message %Mail.Message{
      body: nil,
      headers: %{
        "content-type" => [
          "multipart/alternative",
          {"boundary", "000000000000011db005935fe21f"}
        ],
        "date" => {{2019, 9, 25}, {20, 35, 5}},
        "from" => {"gmax", "abc@gmail.com"},
        "mime-version" => "1.0",
        "subject" => "Hello",
        "to" => ["demo@example.com", "another@example.com"]
      },
      multipart: true,
      parts: [
        %Mail.Message{
          body: "FYI",
          headers: %{"content-type" => ["text/plain", {"charset", "\"UTF-8\""}]},
          multipart: false,
          parts: []
        },
        %Mail.Message{
          body: "<div dir=\"ltr\">FYI</div>",
          headers: %{"content-type" => ["text/html", {"charset", "\"UTF-8\""}]},
          multipart: false,
          parts: []
        }
      ]
    }

    @valid_attrs %{
      email_field: "Email",
      message: @message,
      sheet_values: [
        %{"Email" => "demo@example.com", "FirstName" => "Demo"},
        %{"Email" => "another@example.com", "FirstName" => "Another"}
      ],
      user_id: 36
    }

    def draft_fixture(attrs \\ %{}) do
      {:ok, draft} =
        attrs
        |> Enum.into(@valid_attrs)
        |> GmaxMail.create_draft()

      draft
    end

    test "create_draft/1 with valid data creates a draft" do
      assert {:ok, %Draft{} = draft} = GmaxMail.create_draft(@valid_attrs)
      assert draft.email_field == "Email"

      assert draft.sheet_values == [
               %{"Email" => "demo@example.com", "FirstName" => "Demo"},
               %{"Email" => "another@example.com", "FirstName" => "Another"}
             ]
    end

    test "create_draft/1 auto set to_count field" do
      assert {:ok, %Draft{} = draft} = GmaxMail.create_draft(@valid_attrs)
      assert draft.to_count == 2
    end

    test "create_draft/1 auto set to field" do
      {:ok, %Draft{} = draft} = GmaxMail.create_draft(@valid_attrs)
      assert draft.to == Mail.get_to(@message)
    end

    test "create_draft/1 auto clean to headers" do
      assert {:ok, %Draft{} = draft} = GmaxMail.create_draft(@valid_attrs)
      assert Mail.Message.get_header(draft.message, "to") == []
    end

    test "create_draft/1 set original_to to the to headers of message" do
      assert {:ok, %Draft{} = draft} = GmaxMail.create_draft(@valid_attrs)
      assert draft.original_to == Mail.get_to(@message)
    end

    test "get_unsend_draft/1 returns nil if there is no record" do
      assert nil == GmaxMail.get_unsend_draft(36)
    end

    test "get_unsend_draft/1 returns message if to_count is greater than 0" do
      message = Mail.Message.put_header(@message, "to", [])
      draft_fixture(%{message: message})
      refute GmaxMail.get_unsend_draft(36)

      assert {:ok, %Draft{} = draft} = GmaxMail.create_draft(@valid_attrs)
      d = GmaxMail.get_unsend_draft(36)
      assert d.id == draft.id
    end

    test "get_unsend_draft/1 returns the oldesd draft" do
      assert {:ok, %Draft{} = draft1} = GmaxMail.create_draft(@valid_attrs)
      assert {:ok, %Draft{} = _draft2} = GmaxMail.create_draft(@valid_attrs)
      assert {:ok, %Draft{} = _draft3} = GmaxMail.create_draft(@valid_attrs)
      d = GmaxMail.get_unsend_draft(36)
      assert d.id == draft1.id
    end

    test "update/draft/2" do
      assert {:ok, %Draft{} = draft} = GmaxMail.create_draft(@valid_attrs)
      assert {:ok, draft} = GmaxMail.update_draft(draft, %{to: []})
      assert draft.to == []
    end
  end

  describe "messages" do
    alias Gmax.Mail.Message

    @valid_attrs %{msg_id: "16ddc36fef3d6997", thread_id: "16ddc36fef3d6997", user_id: 1}
    @invalid_attrs %{msg_id: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> GmaxMail.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert GmaxMail.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert GmaxMail.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = GmaxMail.create_message(@valid_attrs)
      assert message.msg_id == @valid_attrs.msg_id
      assert message.thread_id == @valid_attrs.thread_id
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GmaxMail.create_message(@invalid_attrs)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = GmaxMail.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> GmaxMail.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = GmaxMail.change_message(message)
    end
  end
end
