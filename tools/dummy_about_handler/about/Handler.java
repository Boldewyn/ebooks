 package dummy_about_handler.about;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringBufferInputStream;
import java.net.URL;
import java.net.URLConnection;

public class Handler extends java.net.URLStreamHandler {

@Override
protected URLConnection openConnection(URL url) throws IOException  {
    URLConnection res = new URLConnection(url) {

        @Override
        public void connect() throws IOException {
            connected = true;
        }
        @Override
        public InputStream getInputStream() throws IOException {
            return new StringBufferInputStream("<!ELEMENT html ANY>");
        }
    };
    return res;
 }
}
