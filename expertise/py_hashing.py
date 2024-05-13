import hashlib

m = hashlib.sha256(b'text').hexdigest()

print(m.upper()) # gives the same result as sql servers HashBytes('SHA2_256', 'text')