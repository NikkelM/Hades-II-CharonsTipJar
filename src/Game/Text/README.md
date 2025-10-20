# How to contribute a translation

- Copy the `HelpText.en.sjson.lua` file, renaming it with the appropriate language code used by the game, e.g. `HelpText.de.sjson.lua` for German.
- Replace the source path for the `helpTextFile` variable at the bottom of the file to match the new language code.
- Import the new file in `main.lua` as such: `import 'Game/Text/HelpText.en.sjson.lua'`, using the correct language code.
- Translate any or all of the text entries in the new file.
	- Do not change the IDs.
	- Translations don't need to be exact word-for-word, but should keep the same meaning and tone, including how phrases such as "Lord Charon" are translated for the chosen language.
  - Please playtest your changes to ensure all texts fit in the text boxes properly. For latin alphabet languages, the maximum that fits in a dialogue box is around 275 characters.
- Submit a pull request with your changes.
