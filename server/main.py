from dotenv import load_dotenv
load_dotenv()
import os
from rev_ai.speechrec import RevSpeechAPI
rev_client = RevSpeechAPI(os.getenv('REV_KEY'))
from pprint import pprint
from time import sleep

# job_id = 342133076


def transcribe_audio():
    """Transcribe audio"""
    # Create transcription job
    submit_info = rev_client.submit_job_local_file('audio/congress.mp3')
    job_id = submit_info['id']
    # Wait for job to complete
    done = False
    while not done:
        job_info = rev_client.view_job(job_id)
        if job_info['status'] == 'failed':
            # Job failed
            print(job_id + 'failed.')
            done = True
        elif job_info['status'] == 'transcribed':
            # Job transcription is done
            done = True
            transcript_info = rev_client.get_transcript(job_id)
            transcript = ''.join(e['value']
                                 for e in transcript_info['monologues'][0]['elements'])
            print(transcript)
        else:
            # Job not completed
            print(job_id + ' is not completed yet.')
        sleep(1)


def main():
    """Main method to test functions"""
    transcribe_audio()


def summarize():
    pass


if __name__ == '__main__':
    main()
