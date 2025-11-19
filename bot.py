import logging
from telegram import Update, InputFile
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes

BOT_TOKEN = "8480009612:AAFvUj5hSpxHwtehuhXoTf4n9gMSdXOSrQE"

logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user

    # читаем версию
    with open("version.txt", "r") as f:
        version = f.read().strip()

    # собираем сообщение
    text = (
        "<b>ERMAKOV_DEVOPS_BOT</b>\n"
        "Новый выпуск изменений\n\n"
        f"<b>Проект:</b> ermakov-devops\n"
        f"<b>Версия:</b> v{version}\n"
        f"<b>Автор:</b> {user.first_name}\n\n"
        "Информация о Git-репозитории\n"
        f"GIT TAG: v{version}\n\n"
        "Информация о Docker-репозитории\n"
        f"Название: ermakov-devops\n"
        f"Тег: v{version}\n"
    )

    # отправляем сообщение
    await update.message.reply_html(text)

    # прикладываем changelog.md
    try:
        with open("changelog.md", "rb") as f:
            await update.message.reply_document(InputFile(f, filename="changelog.md"))
    except FileNotFoundError:
        await update.message.reply_text("Файл changelog.md не найден.")


def main():
    app = ApplicationBuilder().token(BOT_TOKEN).build()

    app.add_handler(CommandHandler("start", start))

    print("Bot is running...")
    app.run_polling()


if __name__ == '__main__':
    main()