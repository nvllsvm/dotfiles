#!/usr/bin/env python3
import argparse
import os
import shutil
import subprocess
import sys

import enzyme


class MKVFile(object):
    def __init__(self, directory, filename):
        self.directory = directory
        self.filename = filename

        with open(self.path, 'rb') as f:
            self.metadata = enzyme.MKV(f)

    @property
    def path(self):
        return os.path.join(self.directory, self.filename)

    @property
    def languages(self):
        languages = set()

        for track in self.metadata.audio_tracks:
            languages.add(track.language)

        for track in self.metadata.subtitle_tracks:
            languages.add(track.language)

        return languages

    def matching_audio_tracks(self, languages):
        audio_tracks = []
        for track in self.metadata.audio_tracks:
            if track.language in languages:
                audio_tracks.append(track.number - 1)

        return audio_tracks

    def matching_subtitle_tracks(self, languages):
        subtitle_tracks = []
        for track in self.metadata.subtitle_tracks:
            if track.language in languages:
                subtitle_tracks.append(track.number - 1)

        return subtitle_tracks

    def track_string(self, track_type, track_list):
        track_command = []
        if track_list:
            track_command += ['--' + track_type + '-tracks']
            invalid_tracks = "!"

            first_track = True
            for track in track_list:
                if first_track:
                    first_track = False
                else:
                    invalid_tracks += ','

                invalid_tracks += str(track)
            track_command += [invalid_tracks]

        return track_command

    def remove_tracks(self, target_folder, audio=[], subtitle=[]):
        if not os.path.isdir(target_folder):
            os.makedirs(target_folder)

        target_path = os.path.join(target_folder, self.filename)
        if audio or subtitle:
            conversion_call = ['mkvmerge', '-o', target_path]

            conversion_call += self.track_string('audio',
                                                 audio)
            conversion_call += self.track_string('subtitle',
                                                 subtitle)

            conversion_call += [self.path]

            subprocess.check_call(conversion_call,
                                  stdout=open(os.devnull, 'w'))
        else:
            shutil.copy(self.path, target_path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input_directory')
    parser.add_argument('output_directory')
    args = parser.parse_args()

    input_directory = os.path.abspath(args.input_directory)
    output_directory = args.output_directory

    if os.path.exists(output_directory):
        print('Error: output directory exists: {}'.format(output_directory))
        sys.exit()

    valid_languages = set(['eng', 'und', None])

    for root, dirs, files in os.walk(input_directory):
        dirs.sort()
        for filename in sorted(files):
            if filename.lower().endswith('.mkv'):
                mkv_file = MKVFile(root, filename)
                print(mkv_file.path)
                invalid_languages = mkv_file.languages - valid_languages
                new_root = root.replace(input_directory, output_directory, 1)

                audio = mkv_file.matching_audio_tracks(invalid_languages)
                subtitle = mkv_file.matching_subtitle_tracks(invalid_languages)
                mkv_file.remove_tracks(new_root,
                                       audio=audio,
                                       subtitle=subtitle)


if __name__ == '__main__':
    main()
