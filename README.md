# ReadToMe

A phone web app for children age 2 to 6. The phone is a magnifying glass over a real book.

Open it on your phone: https://boblybell.github.io/read-to-me/

- iPhone: open the link in Safari. Tap Share, then "Add to Home Screen".
- Android: open the link in Chrome. Tap the menu, then "Install app".

Everything you add (books, page photos, stickers, voices) is saved only on the phone, in the browser's storage. Nothing is sent to a server.

Stickers come from the real words on the page. Fun facts show only for some words (animals, nature and more).

## Reading the page

The app reads the words on the page on the phone itself, with Tesseract.js (files in `vendor/ocr`, Apache 2.0 licence). Page text is not sent anywhere. When you open a word sticker, only that one word is sent to a free dictionary (dictionaryapi.dev) to get its meaning.
