# https://github.com/casey/just
#
[linux]
run:
  @echo "This will only run on linux"

[macos]
run:
  @echo "This will only run on macos"

foo := if "2" == "2" { "Good!" } else { "1984" }

bar:
  @echo "{{foo}}"
