#!/usr/bin/env bats

# export DOCKER_COMPOSE_STUB_DEBUG=/dev/tty

load '/usr/local/lib/bats/load.bash'
load '../lib/shared'
load '../lib/push'

@test "Image for compose service with an image in config" {
  export HIDE_PROMPT=1
  stub docker-compose \
    "-f docker-compose.yml -p buildkite config : cat $PWD/tests/composefiles/docker-compose.config.v3.2.yml"

  run compose_image_for_service "app"

  assert_success
  assert_output "somewhere.dkr.ecr.some-region.amazonaws.com/blah"
  unstub docker-compose
}

@test "Image for compose service without an image in config" {
  export HIDE_PROMPT=1
  stub docker-compose \
    "-f docker-compose.yml -p buildkite config : cat $PWD/tests/composefiles/docker-compose.config.v3.2.yml"

  run compose_image_for_service "helper"

  assert_success
  assert_output "buildkite_helper"
  unstub docker-compose
}