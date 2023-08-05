	<html>
    <head>
        <title>Basic queries</title>
    </head>

    <body>
        <h2>Display Tables</h2>
        <p>If you wish to see any table, select its name and press on the display button.</p>

        <form method="GET" action="basicQueries.php">
            <!-- if you want another page to load after the button is clicked, you have to specify that page in the action parameter -->
            <input type="hidden" id="displayTablesRequest" name="displayTablesRequest">
						Table: <select name="tName"> 
                    <option>Player</option>
                    <option>Team</option>
                    <option>Club</option>
										<option>Coach_C1</option>
                    <option>Coach_C2</option>
                    <option>Agent</option>
										<option>Sponsor</option>
                    <option>Game</option>
                    <option>Stadium_PNAS</option>
										<option>Stadium_PCI</option>
                    <option>Stadium_PCO</option>
                    <option>Stage</option>
                  </select> <br /> <br />
            <p><input type="submit" value="Display" name="displayTuples"></p>
        </form>

        <hr />

        <h2>Insert Teams into Table</h2>
        <form method="POST" action="basicQueries.php"> <!--refresh page when submitted-->
            <input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
            ClubID: <input type="text" name="insID"> <br /><br />
            Team Name: <input type="text" name="insName"> <br /><br />
            <input type="submit" value="Insert" name="insertTuples"></p>
        </form>

        <hr />

        <h2>Update Team Names in Table</h2>
        <p>The values are case sensitive and if you enter in the wrong case, the update statement will not do anything.</p>

        <form method="POST" action="basicQueries.php"> <!--refresh page when submitted-->
            <input type="hidden" id="updateQueryRequest" name="updateQueryRequest">
            Old Team Name: <input type="text" name="oldName"> <br /><br />
            New Team Name: <input type="text" name="newName"> <br /><br />
            <input type="submit" value="Update" name="updateTuples"></p>
        </form>

        <hr />

        <h2>Delete Teams from Table</h2>
        <form method="POST" action="basicQueries.php"> <!--refresh page when submitted-->
            <input type="hidden" id="deleteQueryRequest" name="deleteQueryRequest">
						ClubID: <input type="text" name="insID"> <br /><br />
            Team Name: <input type="text" name="insName"> <br /><br />
            <input type="submit" value="Delete" name="deleteTuples"></p>
        </form>

				<hr />

        <h2>Count the Tuples in Displayed Table</h2>
        <form method="GET" action="basicQueries.php"> <!--refresh page when submitted-->
            <input type="hidden" id="countQueryRequest" name="countQueryRequest">
						Table: <select name="tName"> 
                    <option>Player</option>
                    <option>Team</option>
                    <option>Club</option>
										<option>Coach_C1</option>
                    <option>Coach_C2</option>
                    <option>Agent</option>
										<option>Sponsor</option>
                    <option>Game</option>
                    <option>Stadium_PNAS</option>
										<option>Stadium_PCI</option>
                    <option>Stadium_PCO</option>
                    <option>Stage</option>
                  </select> <br /> <br />
            <input type="submit" value="Count" name="countTuples"></p>
        </form>

        <?php
		//this tells the system that it's no longer just parsing html; it's now parsing PHP

        $success = True; //keep track of errors so it redirects the page only if there are no errors
        $db_conn = NULL; // edit the login credentials in connectToDB()
        $show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

        function debugAlertMessage($message) {
            global $show_debug_alert_messages;

            if ($show_debug_alert_messages) {
                echo "<script type='text/javascript'>alert('" . $message . "');</script>";
            }
        }

        function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
            // echo "<br>running ".$cmdstr."<br>";
            global $db_conn, $success;

            $statement = OCIParse($db_conn, $cmdstr);
            //There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
                echo htmlentities($e['message']);
                $success = False;
            }

            $r = OCIExecute($statement, OCI_DEFAULT);
            if (!$r) {
                echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
                echo htmlentities($e['message']);
                $success = False;
            }

			return $statement;
		  }

        function executeBoundSQL($cmdstr, $list) {
            /* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
						In this case you don't need to create the statement several times. Bound variables cause a statement to only be
						parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
						See the sample code below for how this function is used */

			global $db_conn, $success;
			$statement = OCIParse($db_conn, $cmdstr);

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn);
                echo htmlentities($e['message']);
                $success = False;
            }

            foreach ($list as $tuple) {
                foreach ($tuple as $bind => $val) {
                    //echo $val;
                    //echo "<br>".$bind."<br>";
                    OCIBindByName($statement, $bind, $val);
                    unset ($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
				}

                $r = OCIExecute($statement, OCI_DEFAULT);
                if (!$r) {
                    echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                    $e = OCI_Error($statement); // For OCIExecute errors, pass the statementhandle
                    echo htmlentities($e['message']);
                    echo "<br>";
                    $success = False;
                }
            }
        }

				function printTable($result) { // print tables
					$ncols = oci_num_fields($result);

					// echo "<br>Retrieved data: <br> <p> </p>";
					echo "<table>";

					echo "<tr>";
					for ($i = 1; $i <= $ncols; $i++) {
							$column_name  = oci_field_name($result, $i);
							echo "<th>$column_name</th>";
					}
					echo "</tr>";

					while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
							echo "<tr>";
							for ($i = 0; $i < $ncols; $i++) {
								 echo "<td>" . $row[$i] . "</td>";
							}
							echo "</tr>";
					}

					echo "</table>";
			}


        function connectToDB() {
            global $db_conn;

            // Your username is ora_(CWL_ID) and the password is a(student number). For example,
			// ora_platypus is the username and a12345678 is the password.
            $db_conn = OCILogon("ora_scenery", "a68414689", "dbhost.students.cs.ubc.ca:1522/stu");

            if ($db_conn) {
                debugAlertMessage("Database is Connected");
                return true;
            } else {
                debugAlertMessage("Cannot connect to Database");
                $e = OCI_Error(); // For OCILogon errors pass no handle
                echo htmlentities($e['message']);
                return false;
            }
        }

        function disconnectFromDB() {
            global $db_conn;

            debugAlertMessage("Disconnect from Database");
            OCILogoff($db_conn);
        }

        function handleShowRequest() {
						global $db_conn;
            $table_name = $_GET['tName'];

            switch($table_name) {
							case "Player": 
								$sql_statement = executePlainSQL("SELECT * FROM Player");
									break;
							case "Team":
									$sql_statement = executePlainSQL("SELECT * FROM Team");
									break;
							case "Club": 
									$sql_statement = executePlainSQL("SELECT * FROM Club");
									break;
							case "Coach_C1": 
									$sql_statement = executePlainSQL("SELECT * FROM Coach_C1");
									break;
							case "Coach_C2":
									$sql_statement = executePlainSQL("SELECT * FROM Coach_C2");
									break;
							case "Agent": 
									$sql_statement = executePlainSQL("SELECT * FROM Agent");
									break;
							case "Sponsor": 
								$sql_statement = executePlainSQL("SELECT * FROM Sponsor");
									break;
							case "Game":
									$sql_statement = executePlainSQL("SELECT * FROM Game");
									break;
							case "Stadium_PNAS": 
									$sql_statement = executePlainSQL("SELECT * FROM Stadium_PNAS");
									break;
							case "Stadium_PCI": 
									$sql_statement = executePlainSQL("SELECT * FROM Stadium_PCI");
									break;
							case "Stadium_PCO":
									$sql_statement = executePlainSQL("SELECT * FROM Stadium_PCO");
									break;
							case "Stage": 
									$sql_statement = executePlainSQL("SELECT * FROM Stage");
									break;
            }
            echo "<br>Table $table_name <br>";
            printTable($sql_statement);
        }

        function handleInsertRequest() {
            global $db_conn;
						$team_table = "Team";

            //Getting the values from user and insert data into the table
            $tuple = array (
                ":bind1" => $_POST['insID'],
                ":bind2" => $_POST['insName']
            );

            $alltuples = array (
                $tuple
            );

            executeBoundSQL("insert into $team_table values (:bind1, :bind2)", $alltuples);
            OCICommit($db_conn);
        }

				function handleUpdateRequest() {
					global $db_conn;
					$team_table = "Team";

					$old_name = $_POST['oldName'];
					$new_name = $_POST['newName'];

					// you need the wrap the old name and new name values with single quotations
					executePlainSQL("UPDATE $team_table SET team_name='" . $new_name . "' WHERE team_name='" . $old_name . "'");
					OCICommit($db_conn);
			}

			function handleDeleteRequest() {
				global $db_conn;
				$team_table = "Team";

				//Getting the values from user and delete data from the table
				$insID = isset($_POST['insID']) ? $_POST['insID'] : '';
			  $insName = isset($_POST['insName']) ? $_POST['insName'] : '';

				executePlainSQL("DELETE FROM $team_table WHERE clubID = '$insID' AND team_name = '$insName'");
				OCICommit($db_conn);
		}

        function handleCountRequest() {
					global $db_conn;
					$table_name = $_GET['tName'];

					$result = executePlainSQL("SELECT Count(*) FROM $table_name");

					if (($row = oci_fetch_row($result)) != false) {
							echo "<br> The number of tuples in $table_name Table: " . $row[0] . "<br>";
					}
        }

        // HANDLE ALL POST ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handlePOSTRequest() {
            if (connectToDB()) {
                if (array_key_exists('insertTuples', $_POST)) {
									handleInsertRequest();
                } else if (array_key_exists('updateTuples', $_POST)) {
                  handleUpdateRequest();
                } else if (array_key_exists('deleteTuples', $_POST)) {
									handleDeleteRequest();
                }

                disconnectFromDB();
            }
        }

        // HANDLE ALL GET ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handleGETRequest() {
            if (connectToDB()) {
                if (array_key_exists('displayTuples', $_GET)) {
									handleShowRequest();
                } else if (array_key_exists('countTuples', $_GET)) {
									handleCountRequest();
							}

                disconnectFromDB();
            }
        }

		if (isset($_POST['insertTuples']) || isset($_POST['updateTuples']) || isset($_POST['deleteTuples'])) {
            handlePOSTRequest();
        } else if (isset($_GET['displayTuples']) || isset($_GET['countTuples'])) {
            handleGETRequest();
        }

        // Study note:
				// displayTablesRequest
				// insertQueryRequest
				// updateQueryRequest
				// deleteQueryRequest
				// countQueryRequest
				// displayTuples
				// insertTuples
				// updateTuples
				// deleteTuples
				// countTuples
		?>
	</body>
</html>
