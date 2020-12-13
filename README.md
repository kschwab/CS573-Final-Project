# CS573 Final Project

CS573 final project demonstrating Flatpak applications. Flatpak is a container technology that is focused on running applications in an isolated environment local to the system. Unlike Docker, Flatpak is intended to integrate more seamlessly with the local system resources, providing an integrated feel. A basic overview Flatpak can be found [here](https://docs.flatpak.org/en/latest/basic-concepts.html).

![Flatpak](https://docs.flatpak.org/en/latest/_images/diagram.svg)

# Setup

The project can be either replicated inside of a Docker container, or ran directly on the system. Both setups are outlined below.

## Using Docker to Replicate Project

The project can be reproduced within a Docker container if desired. Instructions for installing Docker onto your system can be found [here](https://docs.docker.com/get-docker/).

To create the Docker image, run the following:
```sh
$ cd <folder of cloned CS573-Final-Project>
$ ./provision/install_docker.sh
```

Installing Flatpak inside of Docker requires the use of the `--privileged` flag, which is not supported by Dockerfile. Therefore, there are two options:

- Use the default Docker image created, which will require installing the project Flatpaks every time the container is executed.
- Create a new Docker image from the default, which will have the project Flatpaks pre-installed.

### Using the Default Docker Image

Using the default Docker image will require installing the project Flatpaks every time it is executed. To run the default Docker image and install the project Flatpaks inside, run the following:

```sh
$ docker run -it --rm --privileged cs573-final-project
$ ./provision/install_flatpaks.sh
```

### Creating a New Docker Image from the Default

To have the project Flatpaks installed within the container by default, we'll need to create a new Docker image from the default by running the following:

```sh
$ docker run -it --privileged cs573-final-project
$ ./provision/install_flatpaks.sh
$ exit
$ docker ps -a

CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                     PORTS           NAMES
f09565b330c8        cs573-final-project   "/bin/bash"         8 minutes ago       Exited (0) 6 seconds ago                   thirsty_almeida
...                 ...                   ...                 ...                 ...                                        ...

$ docker commit <Container ID of exited cs573-final-project image> cs573-final-project-with-flatpaks-installed
```
_More info on Docker commit can be found [here](https://docs.docker.com/engine/reference/commandline/commit/) if needed._

The following can then be ran without having to install the project Flatpaks every time the container is executed:

```sh
$ docker run -it --rm --privileged cs573-final-project-with-flatpaks-installed
```

## Using Flatpak (on System) to Replicate Project

For replicating the project directly on your system, you will need to install Flatpak. Instructions for installing Flatpak onto your system can be found [here](https://flatpak.org/setup/).

While not required, it is recommended to export the following paths. To update the PATH environment variable, add the following to your `.bashrc` for permanent use, or execute the below on the command line for temporary use:
```sh
export PATH=$PATH:~/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin
```

To create and install the project Flatpaks, run the following:
```sh
$ cd <folder of cloned CS573-Final-Project>
$ ./provision/install_flatpaks.sh
```

# Running the Project Flatpak Apps

There are three different project Flatpak applications, each highlighting different aspects of Flatpak.
1. A 'base' application `boisestate.cs573.BaseShellApp`, which is an app that demonstrates how most Flatpak applications are packaged.
2. An 'extension' application `boisestate.cs573.ExtensionShellApp`, which is an app that utilizes a runtime extension.
3. An 'SDK' application `boisestate.cs573.SdkShellApp`, which is an app based off a custom runtime SDK.

To view the installed Flatpak applications, run:
```sh
$ flatpak list
Name                       Application ID                               Version                   Branch         Origin                          Installation
BaseShellApp               boisestate.cs573.BaseShellApp                                          stable         baseshellapp-origin             user
ExtensionShellApp          boisestate.cs573.ExtensionShellApp                                     stable         extensionshellapp-origin        user
Sdk                        boisestate.cs573.Sdk                                                   20.08          sdk-origin                      user
SdkShellApp                boisestate.cs573.SdkShellApp                                           stable         sdkshellapp-origin              user
Visual Studio Code         com.visualstudio.code                        1.51.1-1605051630         stable         flathub                         user
default                    org.freedesktop.Platform.GL.default                                    20.08          flathub                         user
Intel                      org.freedesktop.Platform.VAAPI.Intel                                   20.08          flathub                         user
openh264                   org.freedesktop.Platform.openh264            2.1.0                     2.0            flathub                         user
Freedesktop SDK            org.freedesktop.Sdk                          20.08.2                   20.08          flathub                         user
cs573                      org.freedesktop.Sdk.Extension.cs573                                    20.08          cs573-origin                    user
```

The `boisestate.cs573.Sdk` is the custom runtime we've created based off of the freedesktop SDK runtime. Similarly, the `org.freedesktop.Sdk.Extension.cs573` is the runtime extension we've created against the freedesktop SDK runtime. Neither of these are 'applications' and thus cannot be invoked directly as they are intended to only be used by the applications themselves.

Each project app provides the same thing, which is a basic shell inside of the sandbox that overrides gcc to a dummy gccX compiler, and will look something like the below once the app is executed:
```sh
kschwab@boisestate.cs573.App ~
[📦]$ gcc
gccX is installed as default compiler.
kschwab@boisestate.cs573.App ~
[📦]$
```

This will look and feel as though a virtual environment has been overlayed onto the local system (or Docker container). However, not everything is present as we are limited to whatever is provided in the SDK runtime. For example, `man` entries will not work. If we wanted `man` entries to work we could add them to our app layer, extend the runtime, or create a new runtime with them included.

To run the project Flatpaks (either inside Docker container or locally on the system), run:

_If PATH environment variable has been updated:_
- Base Shell App: `$ boisestate.cs573.BaseShellApp`
- Extension Shell App: `$ boisestate.cs573.ExtensionShellApp`
- SDK Shell App: `$ boisestate.cs573.SdkShellApp`

_If PATH environment variable has not been updated:_
- Base Shell App: `$ flatpak run boisestate.cs573.BaseShellApp`
- Extension Shell App: `$ flatpak run boisestate.cs573.ExtensionShellApp`
- SDK Shell App: `$ flatpak run boisestate.cs573.SdkShellApp`

# Overriding Flatpak Runtimes

Flatpak allows for overriding the runtime that is associated with an application. To demonstrate this, we will use the [Visual Studio Code App](https://flathub.org/apps/details/com.visualstudio.code) (com.visualstudio.code) to override the default runtime with our own (`boisestate.cs573.Sdk`). The Flatpak `--command=sh` argument, allows us to run a shell inside of the runtime instead of launching the default application command. We will then override the runtime by specifying `--runtime=boisestate.cs573.Sdk`. Run the following (either inside Docker container or locally on the system) to observe the differences:

```sh
$ flatpak run --command=sh com.visualstudio.code
[📦 com.visualstudio.code ~]$ gcc --version
gcc (GCC) 10.2.0
...
[📦 com.visualstudio.code ~]$ exit
$ flatpak run --command=sh --runtime=boisestate.cs573.Sdk com.visualstudio.code
kschwab@boisestate.cs573.App ~
[📦]$ gcc --version
gccX is installed as default compiler.
kschwab@boisestate.cs573.App ~
[📦]$ exit
```
