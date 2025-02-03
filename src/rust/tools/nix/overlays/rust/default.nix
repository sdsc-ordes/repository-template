{ inputs, ... }:
# Import the inputs which returns an overlay function which
# we directly return.
(import inputs.rust-overlay)
