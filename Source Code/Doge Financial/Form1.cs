using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;                                                           

//this project uses MySql, AES and simpleTCP

//project repository and UI management
namespace Doge_Financial
{
    public partial class Form1 : Form
    {
        //initialize ther classes
        private IdentityManagement identity = new IdentityManagement();
        private AccountManagement account = new AccountManagement();
        private MessageManagment message = new MessageManagment();
        private ConnectionManagement connection = new ConnectionManagement();
        //initialize global variables 
        private bool userSelected = false;
        private int incorrectAttempt = 0;

        //initialize form
        public Form1()
        {
            InitializeComponent();
        }

        //submition button, verify account
        private void btnSubmit_Click_1(object sender, EventArgs e)
        {
            //get the users inputted text
            string user = txtUsername.Text;
            string pass = txtPassword.Text;

            //verify that the user has typed something
            if (user != "" && pass != "")
            {
                //validate login details
                bool validate = identity.ValidateLogin(user, pass);

                //if details are valid
                if (validate)
                {
                    //revert all UI information to default state
                    incorrectAttempt = 0;
                    txtUsername.Text = "";
                    txtPassword.Text = "";
                    txtMessage.Text = "";
                    chboxImportant.Checked = false;
                    lstUsers.SelectedItem = null;
                    lstMessages.DataSource = null;
                    userSelected = false;

                    //check current connection status and connect to server
                    if (!ConnectionManagement.connectionStatus)
                        connection.Connect();

                    //wait to insure connection is tested before proceeding
                    wait(100);
                    //if not connected, display info to user
                    if (!ConnectionManagement.connectionStatus)
                        lblConnectionStatus.Text = "ERROR: NO SERVER CONNECTION";

                    //change UI 
                    LayoutChangeLogin();
                    //get and display all other accounts
                    account.GetOtherUsers(IdentityManagement.getID);
                    lstUsers.DataSource = AccountManagement.getAccounts.Item1;
                    lstMessages.Items.Add("Select User");
                }
                else //if details are not valid
                {
                    //count how many incorrect attempts have bean made
                    incorrectAttempt += 1;
                    //if there is less than 10 incorrect attempts 
                    if (incorrectAttempt < 10)
                    {
                        //display to the user that details are not valid 
                        lblErrorLog.Text = "ERROR: INCORRECT INFORMATION";
                        wait(1500);
                        lblErrorLog.Text = "";
                    }
                    else //if there is more than 10 incorrect attempts
                    {
                        //disable button and display the appliction lock
                        btnSubmit.Enabled = false;
                        lblErrorLog.Text = "ERROR: TOO MANY FAILED ATTEMPTS \r\n (5 MINUTE FREEZE)";
                        //wait to insure the error text is updated before sleep
                        wait(100);
                        //program lock for 5 minutes
                        Thread.Sleep(300000);
                        //enable button and restart attempt counter
                        btnSubmit.Enabled = true;
                        lblErrorLog.Text = "";
                        incorrectAttempt = 0;
                    }
                }
            }
        }

        //account list, displays massages of selected account
        private void lstUsers_Click(object sender, EventArgs e)
        {
            //checks if the user has selected an account
            if (lstUsers.SelectedItem != null)
            {
                userSelected = true;

                //gets the selected accounts id
                int itemIndex = lstUsers.Items.IndexOf(lstUsers.SelectedItem.ToString());
                string receiverID = AccountManagement.getAccounts.Item2[itemIndex];

                //retrieves the messages to the database
                lstMessages.DataSource = message.RetrieveMessage(receiverID, IdentityManagement.getID);

                //update message database
                message.UpdateNewMessages(receiverID, itemIndex, IdentityManagement.getID);
            }
        }

        //submit message button
        private void btnEnter_Click(object sender, EventArgs e)
        {
            //checks if a user is selected and a message has been sent 
            if (userSelected && txtMessage.Text != "")
            {
                //gets the selected accounts id
                int itemIndex = lstUsers.Items.IndexOf(lstUsers.SelectedItem.ToString());
                string receiverID = AccountManagement.getAccounts.Item2[itemIndex];

                //get the users inputted values
                string message = txtMessage.Text;
                bool important = chboxImportant.Checked;

                //adds the message to the database
                this.message.SendMessage(receiverID, message, important, IdentityManagement.getID);

                //revierts UI
                txtMessage.Text = "";
                chboxImportant.Checked = false;

                //retrieves the messages to the database (updating the user)
                lstMessages.DataSource = this.message.RetrieveMessage(receiverID, IdentityManagement.getID);

                //check current connection status and sends the messaged accounts id to the server
                if (ConnectionManagement.connectionStatus)
                    connection.WriteToServer(receiverID);

                //spam protection, one second between messages
                btnEnter.Enabled = false;
                wait(1000);
                btnEnter.Enabled = true;
            }
        }

        //Spam Protection, timer that does not lock the program
        public void wait(int milliseconds)
        {
            //initialize timer
            System.Windows.Forms.Timer timer1 = new System.Windows.Forms.Timer();
            //checks if timer has ended
            if (milliseconds == 0 || milliseconds < 0) return;
            //starts timer
            timer1.Interval = milliseconds;
            timer1.Enabled = true;
            timer1.Start();
            timer1.Tick += (s, e) =>
            {
                //stops timer
                timer1.Enabled = false;
                timer1.Stop();
            };
            while (timer1.Enabled)
            {
                //recalls function
                Application.DoEvents();
            }
        }

        //changes UI, all UI element are on one form ,this takes the user to the messaging scene
        private void LayoutChangeLogin()
        {
            txtUsername.Enabled = false;
            txtPassword.Enabled = false;
            lblUsername.Enabled = false;
            lblPassword.Enabled = false;
            btnSubmit.Enabled = false;

            txtUsername.Visible = false;
            txtPassword.Visible = false;
            lblUsername.Visible = false;
            lblPassword.Visible = false;
            btnSubmit.Visible = false;


            lstUsers.Enabled = true;
            lstMessages.Enabled = true;
            txtMessage.Enabled = true;
            chboxImportant.Enabled = true;
            btnEnter.Enabled = true;
            btnLogout.Enabled = true;

            lstUsers.Visible = true;
            lstMessages.Visible = true;
            txtMessage.Visible = true;
            chboxImportant.Visible = true;
            btnEnter.Visible = true;
            btnLogout.Visible = true;
        }

        //changes UI, all UI element are on one form this takes the user to the login scene
        private void LayoutChangeLogout()
        {
            txtUsername.Enabled = true;
            txtPassword.Enabled = true;
            lblUsername.Enabled = true;
            lblPassword.Enabled = true;
            btnSubmit.Enabled = true;

            txtUsername.Visible = true;
            txtPassword.Visible = true;
            lblUsername.Visible = true;
            lblPassword.Visible = true;
            btnSubmit.Visible = true;


            lstUsers.Enabled = false;
            lstMessages.Enabled = false;
            txtMessage.Enabled = false;
            chboxImportant.Enabled = false;
            btnEnter.Enabled = false;
            btnLogout.Enabled = false;

            lstUsers.Visible = false;
            lstMessages.Visible = false;
            txtMessage.Visible = false;
            chboxImportant.Visible = false;
            btnEnter.Visible = false;
            btnLogout.Visible = false;
        }

        //on form initialization actions
        private void Form1_Load(object sender, EventArgs e)
        {
            //hide the error log 
            lblErrorLog.Text = "";
            //sets up clients, server variables 
            ConnectionManagement.SetClient = this;
            connection.ClientSetUp();
        }

        //updates infromation based on information retrieved from the server
        public void RetrieveServerInfo(string serverStatus)
        {
            //invokes the list box to work on a different thread 
            lstUsers.Invoke((MethodInvoker)delegate ()
            {
                //checks if the sent servers id is equal to the users, thus the information needs updated 
                if (IdentityManagement.getID.ToString() == serverStatus)
                {
                    //gets the selected accounts id
                    int itemIndex = lstUsers.Items.IndexOf(lstUsers.SelectedItem.ToString());
                    string receiverID = AccountManagement.getAccounts.Item2[itemIndex];

                    //get and display all other accounts
                    account.GetOtherUsers(IdentityManagement.getID);
                    lstUsers.DataSource = AccountManagement.getAccounts.Item1;

                    //the update sets the selected item to the 1st account 
                    //checkes if a user was selected before the update
                    if (userSelected)
                    {
                        //sets selected account to the account that was selected before the update
                        for (int i = 0; i < AccountManagement.getAccounts.Item2.Count; i++)
                        {
                            if (receiverID == AccountManagement.getAccounts.Item2[i])
                                lstUsers.SelectedIndex = i;
                        }
                        //retrieves the messages to the database (updating the user)
                        lstMessages.DataSource = message.RetrieveMessage(receiverID, IdentityManagement.getID);
                    }
                }
            });
        }

        //logout button, reverts back to loggin infromation and UI
        private void btnLogout_Click(object sender, EventArgs e)
        {
            //removes the saved id
            identity.Logout();
            //revert all UI information to default state
            txtMessage.Text = "";
            chboxImportant.Checked = false;
            lstUsers.SelectedItem = null;
            lstMessages.DataSource = null;
            userSelected = false;
            //changes UI back to the login state
            LayoutChangeLogout();
        }
    }
}
