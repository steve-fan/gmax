defmodule Gmax.MailerTest do
  use Gmax.DataCase
  alias Gmax.Mailer

  describe "extract_internal_vars/1" do
    test "returns a hash in which most values are nil when param is string" do
      to = "demo@example.com"
      vars = Mailer.extract_internal_vars(to)

      assert vars == %{
               "FirstName" => nil,
               "LastName" => nil,
               "FullName" => nil,
               "Email" => to,
               "__to" => to
             }
    end

    test "returns a hash which contains name fields when the param is a tuple" do
      to = {"Michael Jordan", "michael.jordan@example.com"}
      vars = Mailer.extract_internal_vars(to)

      assert vars == %{
               "FirstName" => "Michael",
               "LastName" => "Jordan",
               "FullName" => "Michael Jordan",
               "Email" => "michael.jordan@example.com",
               "__to" => to
             }
    end

    test "returns a hash which contains name fields when the param is a list" do
      to = ["Michael Jordan", "michael.jordan@example.com"]
      vars = Mailer.extract_internal_vars(to)

      assert vars == %{
               "FirstName" => "Michael",
               "LastName" => "Jordan",
               "FullName" => "Michael Jordan",
               "Email" => "michael.jordan@example.com",
               "__to" => {"Michael Jordan", "michael.jordan@example.com"}
             }
    end
  end
end
