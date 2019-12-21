#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# This program is dedicated to the public domain under the CC0 license.

"""
Banshee - 2019
Banserver Telegram Bot Savenotes.
Appends shared messages on configurable markdown file

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
import re
import traceback
import sys
import numpy as np

FILE_DELIM = "## Unclassified\n"


# Config
appDir = os.path.dirname(__file__)
config = Config(os.path.join(appDir, 'telbot-savenotes.cfg'))
telegram_id = config.telegram_id
savenotes_path = config.savenotes_path


# Logger
logging.basicConfig(format='[TELBOT-SAVENOTES]|[%(asctime)s] -- %(levelname)s - %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)


# Define a few command handlers. These usually take the two arguments update and
# context. Error handlers also receive the raised TelegramError object in error.
def startCallback(update, context):
    """Send a message when the command /start is issued."""
    update.message.reply_text('Hi!')


def helpCallback(update, context):
    """Send a message when the command /help is issued."""
    update.message.reply_text('Help!')


def messageCallback(update, context):
    """Echo the user message."""
    try:
        saveNote(update.message.text)
        update.message.reply_text("Message Saved!")
    except Exception as e:
        logger.error('Exception Trace "%s"', traceback.format_exception(None, e, e.__traceback__))
        raise

def errorCallback(update, context):
    """Log Errors caused by Updates."""
    logger.warning('Update "%s" caused error "%s"', update, context.error)
    logger.warning('Details "%s"', context.error.__dict__)
    
def main():
    """Start the bot."""
    # Create the Updater and pass it your bot's token.
    # Make sure to set use_context=True to use the new context based callbacks
    # Post version 12 this will no longer be necessary
    updater = Updater(telegram_id, use_context=True)

    # Get the dispatcher to register handlers
    dp = updater.dispatcher

    # on different commands - answer in Telegram
    dp.add_handler(CommandHandler("start", startCallback))
    dp.add_handler(CommandHandler("help", helpCallback))

    # on noncommand i.e message - echo the message on Telegram
    dp.add_handler(MessageHandler(Filters.text, messageCallback))

    # log all errors
    dp.add_error_handler(errorCallback)

    # Start the Bot
    updater.start_polling()

    # Run the bot until you press Ctrl-C or the process receives SIGINT,
    # SIGTERM or SIGABRT. This should be used most of the time, since
    # start_polling() is non-blocking and will stop the bot gracefully.
    updater.idle()


def saveNote(msg):
    logger.info('Note Received "%s"', msg)
    
    url = getUrl(s=msg)
    if not url is None:
        note = makeUrlNote(url=url, msg=msg)
    else:
        note = makeDefaultNote(msg=msg)
        
    writeNote(noteList=note)
        
def getUrl(s):
    searchRes = re.search("(?P<url>https?://[^\s]+)", s)
    if searchRes:
        return searchRes.group("url")
    else:
        return None

def makeUrlNote(url, msg):
    website = None
    title = None
    description = None
    imgUrl = None

    response = requests.get(url)
    soup = BeautifulSoup(response.text, features="html.parser")
    metas = soup.find_all('meta')

    for meta in metas:
        if 'property' in meta.attrs and 'content' in meta.attrs:
            prop = meta.attrs['property']
            content = meta.attrs['content']
            if prop == 'og:site_name':
                website = content
            elif prop == 'og:title':
                title = content
            elif prop == 'og:image':
                imgUrl = content
            elif prop == 'og:description':
                description = content
                
    for meta in metas:
        if 'name' in meta.attrs and 'content' in meta.attrs:
            content = meta.attrs['content']
            if title is None and meta.attrs['name'] == 'title':
                title = content
            elif description is None and meta.attrs['name'] == 'description':
                description = content
    
    note_list = []
    if website:
        note_list.append("> **[{}]** -".format(website))
    if title:
        note_list.append("{}\\\n".format(title))
    if description:
        note_list.append("{}\\\n".format(description))
        
    note_list.append("<{}>\\\n".format(url))
    
    if imgUrl:
        note_list.append("![Image]({})".format(imgUrl))
        
    if not title and not description:
        note_list.append("<{}>\\\n".format(msg))
        
    note_list.append('\n')
    
    return note_list

def makeDefaultNote(msg):
    note_list = []
    note_list.append(">{}".format(msg))
    note_list.append('\n')
    return note_list

def writeNote(noteList):
    with open(savenotes_path, "r") as src:
        olines = src.readlines()
    
    # Search delim file list position
    npolines = np.array(olines)
    nidx = np.where(npolines == FILE_DELIM)[0]
    if nidx.size > 0:
        idx = nidx[0] + 1
    else:
        idx = len(olines)
    
    if idx > len(olines):
        idx = len(olines)
        
    now = datetime.datetime.now()
    formattedDate = "\n- **[{}]**\n".format(now.strftime("%Y-%m-%d %H:%M:%S"))
    noteList.insert(0, formattedDate)
    
    olines[idx:idx] = noteList
    with open(savenotes_path, "w") as trg:
        trg.writelines(olines)

# -- MAIN --
if __name__ == '__main__':
    main()
