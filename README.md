# CornHub circuits

This repo contains the Noir code we use to generate the proof of age in the mobile app. When running `nargo compile` the resulting `proof_age.json` in the `target` directory (not committed) is used to make in the mobile app with [Swoir](https://github.com/Swoir/Swoir) to generate the proof.

The Noir is originally from [Ocelots' circuits](https://github.com/ocelots-app/passport-verifier), and has been simplified for the purpose of this hackathon project.

The version 0.19.4 of Noir is used in this project for compatibility reason with the Swoir library that doesn't support yet more recent version of Noir.

Note: the MRZ in Prover.toml is not from a real passport, but one created for testing purposes.
