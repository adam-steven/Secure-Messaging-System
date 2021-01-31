using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using SimpleTCP;

//this project uses MySql, mySqlBackup and simpleTCP

//project repository, sever menagement and UI management
namespace Server
{
    public partial class Form1 : Form
    {
        //initialize form
        public Form1()
        {
            InitializeComponent();
        }

        //initialize global variables 
        private SimpleTcpServer server;

        //on form initialization actions
        private void Form1_Load(object sender, EventArgs e)
        {
            DatabaseManagement database = new DatabaseManagement();

            //update and backup the database
            database.DatabaseClear();
            database.Backup();

            //sets up inital server variables 
            server = new SimpleTcpServer();
            server.Delimiter = 0x13;
            server.StringEncoder = Encoding.UTF8;
            server.DataReceived += Server_DataReceived;

            //if the server has not started 
            if (!server.IsStarted)
            {
                //start the server
                txtStatus.Text += "Server started";
                System.Net.IPAddress ip = System.Net.IPAddress.Parse(txtHost.Text);
                server.Start(ip, Convert.ToInt32(txtPort.Text));
            }
        }

        //retrieve data from the client
        private void Server_DataReceived(object sender, SimpleTCP.Message e)
        {
            //invokes the test box to work on a different thread
            txtStatus.Invoke((MethodInvoker)delegate ()
            {
                //display the retrieved message
                txtStatus.Text += "\r\n" + e.MessageString;
                //send the message to all clients
                server.Broadcast(e.MessageString);
            });
        }

        //server start button
        private void btnStart_Click_1(object sender, EventArgs e)
        {
            //if the server has not started 
            if (!server.IsStarted)
            {
                //start the server
                txtStatus.Text += "Server started";
                System.Net.IPAddress ip = System.Net.IPAddress.Parse(txtHost.Text);
                server.Start(ip, Convert.ToInt32(txtPort.Text));
            }
        }

        //server stop button
        private void btnStop_Click_1(object sender, EventArgs e)
        {
            //if the server has started
            if (server.IsStarted)
            {
                //stop the server
                txtStatus.Text += "\r\n Server stopped";
                server.Stop();
            }
        }
    }
}
