# Analog Pie Circle

Analog Pie Circle is a custom [Garmin Vivoactive](http://amzn.to/2o8swED) Connect IQ watch face.

![Playground](screenshots/analog-pie-circle-screenshot.png)

Project URL: [https://github.com/salcode/analog-pie-circle](https://github.com/salcode/analog-pie-circle)

## Useful Links

- [Analog24](https://github.com/sparksp/Analog24) Example of analog 24 hour watch face.
- Garmin Developer Information
	- [Garmin Connect IQ SDK](https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/_index.html)
	- [Getting Started](https://developer.garmin.com/connect-iq/programmers-guide/getting-started/)
	- [Monkey C Documentation](https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/_index.html): Documentation for the Connect IQ programming language.
	- [Connect IQ Apps with Source Code](http://starttorun.info/connect-iq-apps-with-source-code/)
    - [Sideloading an App](https://developer.garmin.com/connect-iq/programmers-guide/getting-started/#sideloadinganapp): Loading an App on your Garmin without their App Store.
- [Denny Biasiolli's IQ Connect Projects](https://github.com/dennybiasiolli/garmin-connect-iq)

## Command Line Notes

### Run the emulator

```
$ connectiq
```

### Build the App

```
$ monkeyc -o ./bin/analogPieCirlce.prg -m ./manifest.xml -z ./resources/strings/strings.xml;./resources/drawables/drawables.xml; ./source/analogPieCircleApp.mc -y ~/connectiq-sdk-mac-2.1.0/
```

#### Error

This does not currently work and needs to be revised.

```
ERROR: You must provide a private key when compiling.
usage: monkeyc [-a <arg>] [-b] [-d <arg>] [-e] [-g] [-i <arg>] [-k] [-m
               <arg>]
               [-n <arg>] [-o <arg>] [-p <arg>] [-q] [-r] [-t] [-u <arg>]
               [-v] [-w] [-x
               <arg>] [-y <arg>] [-z <arg>]
 -a,--apidb <arg>          API import file
 -b,--buildapi             Build API output files
 -d,--device <arg>         Target device (default: square_watch_sim)
 -e,--package-app          Create an application package.
 -g,--debug                Print debug output
 -i,--import-dbg <arg>     Import api.debug.xml
 -k,--write-db             Write out the api.db file
 -m,--manifest <arg>       Manifest file
 -n,--api-version <arg>    The new API version
 -o,--output <arg>         Output file to create
 -p,--project-info <arg>   projectInfo.xml file to use when compiling
 -q,--carray               Write output as a C array (deprecated)
 -r,--release              Strip debug information
 -t,--unit-test            Enables compilation of unit tests
 -u,--devices <arg>        devices.xml file to use when compiling
 -v,--version              Prints the compiler version
 -w,--warn                 Show compiler warnings
 -x,--excludes <arg>       Add annotations to the exclude list
 -y,--private-key <arg>    Private key to sign builds with
 -z,--rez <arg>            Resource file
com.garmin.monkeybrains.Monkeybrains$ParameterException: You must provide a private key when compiling.
        at com.garmin.monkeybrains.Monkeybrains.main(Monkeybrains.java:1183)
-bash: ./resources/drawables/drawables.xml: Permission denied
-bash: ./source/analogPieCircleApp.mc: Permission denied
```

### Run the App in the emulator

```
$ monkeydo ./bin/analogPieCircleApp.prg
```

## Credits

[Sal Ferrarello](https://salferrarello.com/) / [@salcode](https://twitter.com/salcode)
