require "sinatra"

get "/camera/:action" do
  status 200
  headers \
    "Accept-Ranges" => "bytes",
    "Cache-Control" => "no-cache",
    "Connection"    => "Keep-Alive",
    "Server"        => "GoPro Web Server v1.0",
    "Content-Type"  => "application/octet-stream"
  body "\x00\x00"
end
