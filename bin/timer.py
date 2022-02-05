#!python


import sys
import time

# Print iterations progress
def print_progress_bar(
    iteration, total, prefix='Progress', units=None, suffix='Complete', length=100, fill='█', printEnd="\r"
):
    """
    Call in a loop to create terminal progress bar
    @params:
        iteration   - Required  : current iteration (Int)
        total       - Required  : total iterations (Int)
        prefix      - Optional  : prefix string (Str)
        suffix      - Optional  : suffix string (Str)
        decimals    - Optional  : positive number of decimals in percent complete (Int)
        length      - Optional  : character length of bar (Int)
        fill        - Optional  : bar fill character (Str)
        printEnd    - Optional  : end character (e.g. "\r", "\r\n") (Str)
    """

    if units is None:
        # Default to percentage
        units = ('{0:.1f}%').format(100 * (iteration / float(total)))

    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    print(f'\r{prefix} |{bar}| {units} {suffix}', end=printEnd)
    # Print New Line on Complete
    if iteration == total:
        print()


def countdown(seconds):
    start_time = time.time()
    target_time = start_time + float(seconds)

    total_iters = int((target_time - start_time) // 0.1)
    counter = 0
    while target_time > time.time():
        remaining_time = target_time - time.time()
        if int(remaining_time // 0.1) == 0:
            remaining_time = 0
        units = ('{:.1f}s').format(remaining_time)
        print_progress_bar(counter, total_iters, prefix='Time:', units=units, suffix='Left', length=50)

        # do something, e.g. print the remaining time:
        # print("Countdown: {}h {}min {}s remaining".format(remaining_time // 3600, remaining_time // 60, remaining_time % 60))

        # sleep a bit to save CPU resources
        time.sleep(0.1)
        counter += 1

    print('Done')


if __name__ == '__main__':
    seconds = sys.argv[1]
    countdown(seconds)
