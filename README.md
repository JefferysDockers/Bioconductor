# Bioconductor

A light Bioconductor repo for extension. LaTeX reporting not included.

Note: This document serves dual purpose as the README for a GitHub repo and for the DockerHub repository built from it (as an automated build).

This provides the means to build a base Docker image providing a minimal R Bioconductor environment. The associated DockerHub [bioconductor](https://hub.docker.com/repository/docker/jefferys/bioconductor) repository is automatically built using this repository upon pushing a new tag.

## Versioning

Images are tagged using the following scheme:

* "bioconductor:latest" - The latest version of the image.
* "bioconductor:\<bioc.ver\>" - The latest build for a image based on the specified version of Bioconductor.
* "bioconductor:\<bioc.ver\>-\<repo.ver\>" - A specific build (based on a specific version of this repo) for the given Bioconductor based image.

This container depends on the Rocker r-verse containers as needed by the included version of Bioconductor.

* bioconductor:3.13 - uses [rocker/r-ver:4.1.0](https://hub.docker.com/r/rocker/r-ver) which in turn uses [ubuntu:focal](https://hub.docker.com/_/ubuntu)

All three tagged versions will be built automatically using the DockerHub automation. Local builds only build the fully versioned one, see the following.

## Local Build

To build a image locally based on a specific release by tag, clone the tagged commit, `cd` into the repo, and run the `build.sh` script.

```
git clone --branch <tag> --depth 1 https://github.com/JefferysDockers/bioconductor
cd bioconductor
./build.sh
```

To just clone the latest tagged release, you can try leaving off the "--branch \<tag\>" option. That will work as long as the latest commit on the master branch of GitHub has a tag. It probably does, but if you get an error saying something about "no tag available" you'll have to try again, cloning the repo using the tag explicitly.

This will build an image named "bioconductor:\<bioc.ver\>-\<repo.ver\>". If you want the other tags, you will have to create them yourself, e.g.

```
docker tag bioconductor:<bioc.ver>-<repo.ver> <bioc.ver>
docker tag bioconductor:<bioc.ver>-<repo.ver> latest
```

## How the image build process works:

### Building

DockerHub automation provides for ENV variables in the build environment and a default build process whose steps can be over-ridden by appropriately named scripts in a "hooks" directory. To allow both manual (local) builds and automated DockerHub builds, the `build.sh` script mimics the DockerHub build environment by setting ENV variables and then calling the `hooks/build` script to build the image.

The only difficulty in doing this is providing the "TAG" environmental variable, which is based on the Git tag of the particular GitHub commit that DockerHub is building. Building from a local repo requires reading that with Git, which only works if the local repo contains a tag. If it contains more than one tag, the tag from the last commit in the repo with a tag is used. To build a specific tag, clone only that tagged commit (see [Local Build](#local-build), above).

Repeating the information above, when building locally, only the fully versioned "\<REPO\>:\<tool.ver\>-\<repo.ver\>" image is built. You will have to add tags for "\<REPO\>:\<tool.ver\>" and "\<REPO\>:latest" on your own if you need to.

### DockerHub automation

Every commit on the master branch of the GitHub repo is a release and should be tagged with a different tag formatted as "\<tool.ver\>-\<repo.ver\>"

Pushing a new tag with a hyphen to GitHub master branch will trigger DockerHub to build a new image using the `hooks/build` script and add it to the image repo "\<REPO\>:\<tool.ver\>-\<repo.ver\>". Then the `hooks/post_push` script is run. That will additionally add the tags "\<REPO\>:latest" and "\<REPO\>:\<tool.ver\>". Doing the tagging this way rather than setting three separate automated builds is a much more efficient use of DockerHub resources.

Note that there may be brief periods where the leading commit on the master branch of the GitHub repo is not tagged, or when the "\<REPO\>:latest" image does not match with the latest "\<REPO\>:\<tool.ver\>" and/or "\<REPO\>:\<tool.ver\>-\<repo.ver\>" versions of the image on DockerHub due to time required to run different steps of the build process.

## License notes

Licensing is complicated and not what I want to spend my time on, but here is my best attempt to license this and comply with existing licenses:

* The contents of this repo are licensed using the included [GPL compatible](https://www.gnu.org/licenses/license-list.en.html#ArtisticLicense2) Artistic-2.0 LICENSE to match core Bioconductor package [licensing (2.6)](https://bioconductor.org/developers/package-guidelines/#2-description-file).

* Building the container using the included Dockerfile will result in downloading and aggregating products with various licenses. As with almost all containers, the modification, use, and redistribution of the various products are governed by their respective licenses, not the repo license.

* All use of product names, trademarks, or other identifiers, especially R, Docker, and Bioconductor, are intended only to identify the conceptual entities or products named. No use implies any official or unofficial responsibility, support, or recognition of anything in this repository or what it builds.


