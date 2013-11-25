# GoPro Mock

Mock GoPro Hero interface (API and files)

## Getting Started

From the test directory, simply run:

    $ bundle install
    $ foreman run

If these succeed, two servers should be running:

  * API server: `localhost:8000`
  * web/file server: `localhost:8080`

## Recording API Responses

You can capture API responses from your GoPro for inspection using `curl`.

Connect to your camera's network and run a command like outlined below.
Replace `PASSWORD` with the password you configured.

**Attention:** Using `/camera/DL` will delete the last captured file on your camera.

    $ curl -iv http://10.5.5.9/camera/DL?t=PASSWORD -o response.txt

This will store the HTTP response into a file named `response.txt`.

## Sample Files

Assuming you have `wget` installed, you can create a static snapshot of all
content served from your camera by connecting to it and running the following
command:

    $ wget --recursive --no-clobber --page-requisites --html-extension --restrict-file-names=windows --domains 10.5.5.9:8080 --no-parent 10.5.5.9:8080

For an explanation of what this does, please refer to
[this gist](https://gist.github.com/pmeinhardt/6922049).
