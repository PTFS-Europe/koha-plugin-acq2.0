# koha-plugin-template
This is a template for creating a koha plugin that includes a release script.

Instructions:
- Clone this repository and then change the remote to the repository where you want to store your plugin
- Rename the YourPlugin.pm file in Koha/Plugin - this is the plugin file that you will use to create your plugin
- Rename the YourPlugin folder in the same directory to match the filename
- When ready to upload your plugin to github and create a release, run the release script using the command below

```
npm run release
```

The release script will check the release version of your plugin file so make sure to increment this every time you run a release.