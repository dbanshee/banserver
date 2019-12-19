#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# This program is dedicated to the public domain under the CC0 license.

"""
Banserver Telegram Bot Savenotes.
Usage:
Press Ctrl-C on the command line or send a signal to the process to stop the
bot.
"""

import datetime
import logging
from config import Config
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
import os
import requests
from bs4 import BeautifulSoup

appDir=os.path.dirname(__file__)
config = Config(os.path.join(appDir, 'telbot-savenotes.cfg'))

telegram_id=config.telegram_id
savenotes_path=config.savenotes_path


# Enable logging
logging.basicConfig(format='[TELBOT-SAVENOTES]|[%(asctime)s] -- %(levelname)s - %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)


# Define a few command handlers. These usually take the two arguments update and
# context. Error handlers also receive the raised TelegramError object in error.
def start(update, context):
    """Send a message when the command /start is issued."""
    update.message.reply_text('Hi!')


def help(update, context):
    """Send a message when the command /help is issued."""
    update.message.reply_text('Help!')


def echo(update, context):
    """Echo the user message."""
    saveNote(update.message.text)
    update.message.reply_text("Message Saved!")


def error(update, context):
    """Log Errors caused by Updates."""
    logger.warning('Update "%s" caused error "%s"', update, context.error)


def main():
    """Start the bot."""
    # Create the Updater and pass it your bot's token.
    # Make sure to set use_context=True to use the new context based callbacks
    # Post version 12 this will no longer be necessary
    updater = Updater(telegram_id, use_context=True)

    # Get the dispatcher to register handlers
    dp = updater.dispatcher

    # on different commands - answer in Telegram
    dp.add_handler(CommandHandler("start", start))
    dp.add_handler(CommandHandler("help", help))

    # on noncommand i.e message - echo the message on Telegram
    dp.add_handler(MessageHandler(Filters.text, echo))

    # log all errors
    dp.add_error_handler(error)

    # Start the Bot
    updater.start_polling()

    # Run the bot until you press Ctrl-C or the process receives SIGINT,
    # SIGTERM or SIGABRT. This should be used most of the time, since
    # start_polling() is non-blocking and will stop the bot gracefully.
    updater.idle()


def saveNote(msg):
    logger.info('Note Received "%s"', msg)
    now = datetime.datetime.now()
    formattedDate=now.strftime("%Y-%m-%d %H:%M:%S")
    
    note_list = []
    if msg.startswith('http://') or msg.startswith('https://'):
        url = msg
        response = requests.get(url)
        soup = BeautifulSoup(response.text, features="html.parser")
        metas = soup.find_all('meta')

        website = [ meta.attrs['content'] for meta in metas if 'property' in meta.attrs and meta.attrs['property'] == 'og:site_name' ]
        title = [ meta.attrs['content'] for meta in metas if 'property' in meta.attrs and meta.attrs['property'] == 'og:title' ]
        
        if not title:
            title = [ meta.attrs['content'] for meta in metas if 'name' in meta.attrs and meta.attrs['name'] == 'title' ]
            
        description = [ meta.attrs['content'] for meta in metas if 'property' in meta.attrs and meta.attrs['property'] == 'og:description' ]
        if not description:
            description = [ meta.attrs['content'] for meta in metas if 'name' in meta.attrs and meta.attrs['name'] == 'description' ]     
            
        imgUrl = [ meta.attrs['content'] for meta in metas if 'property' in meta.attrs and meta.attrs['property'] == 'og:image' ]
        
        
        if website:
            note_list.append("> **[{}]** -".format(website[0]))
        if title:
            note_list.append("{}\\".format(title[0]))
        if description:
            note_list.append("{}\\".format(description[0]))
        note_list.append("<{}>\\".format(url))
        if imgUrl:
            note_list.append("![Image]({})".format(imgUrl[0]))
        note_list.append('\n')
    else:
        note_list.append(">{}".format(msg))
        note_list.append('\n')
                             
        
    with open(savenotes_path, "a") as myfile:
        myfile.write("- **["+formattedDate+"]**\n")
        myfile.write('\n'.join(note_list))
        myfile.flush()
        
if __name__ == '__main__':
    main()
