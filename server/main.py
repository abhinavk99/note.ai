from dotenv import load_dotenv
load_dotenv()
import os
from rev_ai.speechrec import RevSpeechAPI
rev_client = RevSpeechAPI(os.getenv('REV_KEY'))
from pprint import pprint
from time import sleep
from apply_filters import apply_filters
from flask import Flask
app = Flask(__name__)

# job_id = 205292554
PATH = 'audio/tennis.mp3'
TEXT = ("Through success and controversy, Facebook CEO Mark Zuckerberg has been "
        "regarded as one of the most brilliant minds of his generation. Now "
        "with a net worth of $66 billion, the young CEO is credited with "
        "creating a social network that has more monthly active users than any "
        "single country in the world has people, and his majority voting rights "
        "give him complete control of the company — which also means he's often "
        "the focal point of any backlash or scandal. And for the last year, "
        "Facebook has faced scandal after scandal. It's been called out on "
        "multiple occasions for the way it handles user data, to the point where "
        "it's led many to debate the pros and cons of free networks like "
        "Facebook that rely on advertisers for revenue. In April, Zuckerberg "
        "was summoned to give 10 hours of testimony to Congress as lawmakers "
        "sought answers about Facebook's role in various events like the 2016 "
        "election and the Cambridge Analytica data-harvesting scandal. In the "
        "midst of the scandals, Zuckerberg has defended Facebook and reiterated "
        "the company's stated mission to connect the world with projects like "
        "bringing internet access to areas without less connectivity through his "
        "charity work, he's poured millions into education efforts and billions "
        "into initiatives for curing the world's diseases. But the recent "
        "revelations have put a spotlight on Zuckerberg and his company like "
        "never before. Here's a look at the timeline of Zuckerberg's career, "
        "from his humble beginnings in a New York suburb to his role as one of "
        "the wealthiest CEOs in the world.")


@app.route('/transcribe', methods=['POST'])
def transcribe():
    transcript = transcribe_audio(PATH)
    if transcript != '':
        return {'transcript': transcript}
    else:
        return {'error': 'Failed'}


def transcribe_audio(path=None):
    """Transcribe audio"""
    # Use default path if none provided
    if path is None:
        path = PATH
    submit_info = rev_client.submit_job_local_file(path)
    job_id = submit_info['id']
    # Wait for job to complete
    done = False
    while not done:
        job_info = rev_client.view_job(job_id)
        if job_info['status'] == 'failed':
            # Job failed
            print(job_id + 'failed.')
            done = True
            return ''
        elif job_info['status'] == 'transcribed':
            # Job transcription is done
            done = True
            transcript_info = rev_client.get_transcript(job_id)
            pprint(transcript_info)
            # Convert transcript information to block of text
            transcript = ''.join(''.join(e['value'] for e in mono['elements'])
                                 for mono in transcript_info['monologues'])
            return transcript
        else:
            # Job not completed
            print(job_id + ' is not completed yet.')
        sleep(1)


def summarize(text=None):
    """Summarize text"""
    # Use default text if none provided
    if text is None:
        text = TEXT
    sentences = apply_filters(text)
    for s in sentences:
        print("- " + s + ".")


def main():
    """Main method to test functions"""
    # transcribe_audio()
    summarize()


if __name__ == '__main__':
    main()
