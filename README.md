# fg_pathbuilder_import

Create a data folder (or just copy the whole project folder) in the Fantasy Ground  extensions folder (on windows, it's under c:\Users\<username>\AppData\Roaming\Smiteworks\Fantasy Grounds\extensions


Launch Fantasy Grounds

Enable the extension for your test campaign

Once the campaign is loaded, you can run the importer by using /impb on the console.  This pops up a window and you can paste the Pathbuilder JSON in and click the button to parse it.  It will add the created character to the "Character Selection Window".

You should load all the resources that you'll need to use, so if you need Secrets of Magic, you'll want that loaded.  At the very least you need the CRB loaded.

## Contributing  

This extension is partitioned into importers for each discrete piece of information to be imported. All importers are located in the scripts/importers directory.

Importers define a single function `import(node, value, key)`, where `node` is the character sheet node, `value` is the value from the pathbuilder json file, and `key` is the associated key from the json file.

To add a new importer:

* Create a new lua file in scripts/importers
* Add a new <Script></Script> element to `extension.xml` referencing the new lua file
* Update import_from_pathbuilder.lua to add the new importer method to the DBMap variable


