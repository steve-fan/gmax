defmodule Gmax.Drive do
  def list_google_sheet(user) do
    conn = Gmax.GoogleApi.new_connection(user)
    params = [q: "mimeType='application/vnd.google-apps.spreadsheet'"]
    {:ok, fileList} = GoogleApi.Drive.V3.Api.Files.drive_files_list(conn, params)
    fileList.files
  end
end
