<html>
    <head>
        <title> 
            Selection, Projection, Join, Division
        </title>
    </head>

    <body>
        <h2>Reset</h2>
        <p>If you wish to reset the table press on the reset button.

        <form method="POST" action="otherQueries.php">
            <input type="hidden" id="resetTablesRequest" name="resetTablesRequest">
            <p><input type="submit" value="Reset" name="reset"></p>
        </form>
        <hr />

        <h2>
            Table display
        </h2>
        <p>If you wish to see any table, select its name and press on the display button.</p>

        <form method="GET" action="otherQueries.php">
            <input type="hidden" id="displayTablesRequest" name="displayTablesRequest">
            Table: <select name="table_name">
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

        <h2>Select Table and Attributes</h2>
        <form method="POST" action="otherQueries.php">
            <input type="hidden" id="selectTableAttribute" name="selectTableAttribute">
            Attribute: <input type="text" name="selectAttribute"> <br /><br />
            Table: <input type="text" name="selectTable"> <br /><br />
            Condition(s): <input type="text" name="selectCondition"> <br /><br />
            <input type="submit" value="Select" name="selectTuples"></p>
        </form>

        <h2>Select Columns in a Table (Projection)</h2>
        <form method="POST" action="otherQueries.php">
            <input type="hidden" id="projectTable" name="projectTable">
            Attribute: <input type="text" name="projectAttribute"> <br /><br />
            Table: <input type="text" name="projectTable"> <br /><br />
            <!-- Condition: <input type="text" name="projectCond"> <br /><br /> -->
            <!-- Condition 2: <input type="text" name="projectCond2"> <br /><br />
            Condition 3: <input type="text" name="projectCond3"> <br /><br /> -->
            <input type="submit" value="Project" name="projectTuples"></p>
        </form>

        <h2>Join Tables</h2>
        <form method="POST" action="otherQueries.php">
            <input type="hidden" id="joinTables" name="joinTables">
            Attribute: <input type="text" name="joinAttribute"> <br /><br />
            First Table: <input type="text" name="joinTableOne"> <br /><br />
            Second Table: <input type="text" name="joinTableTwo"> <br /><br />
            Condition: <input type="text" name="joinCond"> <br /><br />
            <input type="submit" value="Join" name="joinTuples"></p>
        </form>

        <h2>Divide Tables</h2>
        <form method="POST" action="otherQueries.php">
            <input type="hidden" id="divideTables" name="divideTables">
            First Table: <input type="text" name="divideTableOne"> <br /><br />
            Second Table: <input type="text" name="divideTableTwo"> <br /><br />
            <input type="submit" value="Divide" name="divideTuples"></p>
        </form>

        <hr />

        <h2>Count the Tuples in Displayed Table</h2>
        <form method="GET" action="otherQueries.php">
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
            //echo "<br>running ".$cmdstr."<br>";
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

        function printTable($result) { //prints the statement
            $ncols = oci_num_fields($result);

            echo "<br>Retrieved data: <br> <p> </p>";
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
            // $db_conn = OCILogon("ora_zhangi1", "a29544764", "dbhost.students.cs.ubc.ca:1522/stu");
            $db_conn = OCILogon("ora_zhangi1", "a29544764", "dbhost.students.cs.ubc.ca:1522/stu");


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
            $table_name = $_GET['table_name'];

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

    function handleResetRequest() {
        global $db_conn;
        // Drop old table
        executePlainSQL("DROP TABLE demoTable");

        // Create new table
        echo "<br> creating new table <br>";
        executePlainSQL("CREATE TABLE demoTable (id int PRIMARY KEY, name char(30))");
        OCICommit($db_conn);
    }

    function handleCountRequest() {
        global $db_conn;

        $result = executePlainSQL("SELECT Count(*) FROM demoTable");

        if (($row = oci_fetch_row($result)) != false) {
            echo "<br> The number of tuples in demoTable: " . $row[0] . "<br>";
        }
    }

        function handleSelectionRequest() {
        global $db_conn;

        $table = $_POST['selectTable'];
        $attribute = $_POST['selectAttribute'];
        $condition = $_POST['selectCondition'];

        $result = executePlainSQL("SELECT " . $attribute . " FROM " . $table . " WHERE " . $condition . "");
        printTable($result);

        OCICommit($db_conn);

    }

    function handleProjectionRequest() {
        global $db_conn;

        $attribute = $_POST['projectAttribute'];
        $table = $_POST['projectTable'];
        // $condition = $_POST['projectCond'];
        // $condition2 = $_POST['projectCond2'];
        // $condition3 = $_POST['projectCond3'];
        
        $result = executePlainSQL("SELECT " . $attribute . " FROM " . $table . "");
        printTable($result);

        OCICommit($db_conn);
    }

    function handleJoinRequest() {
        global $db_conn;

        $attribute = $_POST['joinAttribute'];

        $table_one = $_POST['joinTableOne'];
        $table_two = $_POST['joinTableTwo'];

        $condition = $_POST['joinCond'];

        $result = executePlainSQL("SELECT " . $attribute . " FROM " . $table_one . ", " . $table_two . " WHERE " . $condition . "");
        printTable($result);

        OCICommit($db_conn);
        
    }

    function handleDivisionRequest() {

        $result = executePlainSQL("SELECT T.team_name FROM teamPlaysInGame T, GameIsInStage G WHERE NOT EXISTS SELECT T1.GID FROM GameIsInStage T1 WHERE T1.GID=G.GID EXCEPT (SELECT GID FROM GameIsInStage");

        // $result = executePlainSQL("SELECT team_name FROM teamPlaysInGame T");

        printTable($result);


        // divide team by all stages in the tournament
    }

    // HANDLE ALL POST ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
    function handlePOSTRequest() {
        if (connectToDB()) {
            if (array_key_exists('selectTableAttribute', $_POST)) {
                handleSelectionRequest();
            } else if (array_key_exists('projectTable', $_POST)) {
                handleProjectionRequest();
            } else if (array_key_exists('joinTables', $_POST)) {
                handleJoinRequest();
            } 
            else if (array_key_exists('divideTables', $_POST)) {
                handleDivisionRequest();
            }

            disconnectFromDB();
        }
    }
        // HANDLE ALL GET ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
    function handleGETRequest() {
        if (connectToDB()) {
            if (array_key_exists('countTuples', $_GET)) {
                handleCountRequest();
            } else if (array_key_exists('displayTuples', $_GET)) {
                handleShowRequest();
            } 
            disconnectFromDB();
        }
    }

    if (isset($_POST['selectTableAttribute']) || isset($_POST['projectTable']) || isset($_POST['joinTables']) || isset($_POST['divideTables'])) {
        handlePOSTRequest();
    } else if (isset($_GET['displayTuples'])|| isset($_GET['countTuples'])) {
        handleGETRequest();
    }
    ?>
</body>
</html>