import hashlib


class Hash:
    """Hash key generator implementation"""

    def __init__(self):
        """
        constructor of the hash key generator class
        hashing algorithm sha256 is being implemented now
        """
        self.hash = hashlib.sha256()

    def generate_hash(self, val: str) -> str:
        """
        Generates hash key for the value passed
        :param val: string value to be hashed
        :return: String value of the key generated
        """
        self.hash.update(val.encode())
        return self.hash.hexdigest()
