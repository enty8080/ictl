"""
This plugin requires HatSploit: https://hatsploit.com
Current source: https://github.com/EntySec/HatSploit
"""

from hatsploit.lib.plugin import Plugin


class HatSploitPlugin(Plugin):
    details = {
        'Name': "Pwny ictl plugin",
        'Plugin': "ictl",
        'Authors': [
            'Ivan Nikolsky (enty8080) - plugin developer',
        ],
        'Description': "Pwny ictl plugin for apple_ios/pwny.",
    }

    commands = {
        'ictl: install': {
            'install': {
                'Description': "Install ictl dynamic library.",
                'Usage': "install",
                'MinArgs': 0,
            }
        }
    }

    def install(self, argc, argv):
        pass

    def load(self):
        pass
