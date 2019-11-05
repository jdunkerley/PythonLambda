from datetime import datetime
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event):
    logger.info(event)

    return {
        'statusCode': 200,
        'body': datetime.now().isoformat()
    }