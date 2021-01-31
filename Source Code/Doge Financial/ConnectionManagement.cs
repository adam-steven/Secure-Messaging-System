using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using SimpleTCP;
using System.Windows.Forms;

//manages the clint's server connection, using simpleTCP
namespace Doge_Financial
{
    class ConnectionManagement
    {
        private static Form1 mainScript;
        private SimpleTcpClient client;
        private string host = "127.0.0.1";
        private string port = "8910";
        private static bool connected = false;

        //send the information retrieved from the server to the repository
        public static bool connectionStatus
        {
            get { return connected; }
        }

        //sets the client script
        public static Form1 SetClient
        {
            set { mainScript = value; }
        }

        //sets up inital client variables 
        public void ClientSetUp()
        {
            client = new SimpleTcpClient();
            client.StringEncoder = Encoding.UTF8;
            client.DataReceived += Client_DataReceived;
        }

        //asstablish connection with the server
        public void Connect()
        {
            try
            {
                client.Connect(host, Convert.ToInt32(port));
                connected = true;
            }
            catch (Exception)
            {
                connected = false;
            }
        }

        //send information to the client
        public void WriteToServer(string receiverID)
        {
            client.WriteLine(receiverID);
        }

        //retrieve information from the server
        public void Client_DataReceived(object sender, SimpleTCP.Message e)
        {
            string serverStatus = "";

            serverStatus = e.MessageString;
            serverStatus = serverStatus.Remove(serverStatus.Length - 1);

            mainScript.RetrieveServerInfo(serverStatus);
        }
    }
}
