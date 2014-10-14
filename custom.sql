-- SQL in this file will be loaded into the database after the webinstaller
-- has been run/mimicked. This means that it will only be run/loaded if
-- skip_webinstaller="1" in config.cfg

-- Make sure language and opaclanguages are both set to 'en'
UPDATE systempreferences SET value = 'en' WHERE variable = 'language';
UPDATE systempreferences SET value = 'en' WHERE variable = 'opaclanguages';
