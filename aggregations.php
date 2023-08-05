<!-- Aggregations queries. 
    Based on the oracle-test.php:
        Test Oracle file for UBC CPSC304 2018 Winter Term 1
        Created by Jiemin Zhang
        Modified by Simona Radu
        Modified by Jessica Wong (2018-06-22) -->

<html>
    <head>
        <title>Aggregations</title>
    </head>

    <body>
        <h2>Here you can find some oddly specific information</h2>
        <hr />
        <h2>Show a table</h2>
        <p>If you wish to see a table, choose a name and press on the show button. </p>

        <form method="GET" action="aggregations.php">
            <input type="hidden" id="showTablesRequest" name="showTablesRequest">
            Name: <select name="tName"> 
                    <option>Coach</option>
                    <option>Player and team</option>
                    <option>Game and stage</option>
                  </select> <br /> <br />
            <p><input type="submit" value="Show" name="showSubmit"></p>
        </form>

        <hr />

        <h2>Aggregation with Group By</h2>
        <form method="POST" action="aggregations.php"> 
            <input type="hidden" id="groupByQueryRequest" name="groupByQueryRequest">
            Find years of experience of the 
            <select name="coach_experience">
                <option>least</option>
                <option>most</option>
            </select> experienced coaches of each nationality <br /> <br/>
            <input type="submit" value="Submit" name="groupBySubmit"></p>
        </form>

        <hr />

        <h2>Aggregation with Having</h2>

        <form method="POST" action="aggregations.php"> 
            <input type="hidden" id="havingQueryRequest" name="havingQueryRequest">
            Find dates of birth of the oldest players who have spent more than <input type="number" name="yearsSpent" style="width: 50px"> years at their club, for each position with at least <input type="number" name = "entries" style="width: 50px"> such entries <br /><br />
            <input type="submit" value="Submit" name="havingSubmit"></p>
        </form>

        <hr />

        <h2>Nested Aggregation with Group By</h2>
        <form method="POST" action="aggregations.php"> 
            Find the games with more scored goals than the average in each stage of the tournament <br/><br/>
            <input type="hidden" id="nestedQueryRequest" name="nestedQueryRequest">
            <input type="submit" value="Submit" name="nestedSubmit"></p>
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
            $db_conn = OCILogon("ora_diakel", "a95044343", "dbhost.students.cs.ubc.ca:1522/stu");

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
                case "Coach": 
                    $sql_statement = executePlainSQL("SELECT * FROM Coach_C2");
                    break;
                case "Player and team":
                    $sql_statement = executePlainSQL("SELECT * FROM Player p, PlayerPlaysForTeam pt WHERE p.PID = pt.PID");
                    break;
                case "Game and stage": 
                    $sql_statement = executePlainSQL("SELECT DISTINCT g.GID, g.address, g.postal_code, g.date_played, g.referee, g.winner, g.goals_scored, gis.SID FROM Game g, GameIsInStage gis WHERE g.GID = gis.GID ORDER BY g.date_played");
                    break;
            }

            echo "<br>Table $table_name <br>";
            printTable($sql_statement);
            
        }

        function handleGroupByRequest() {
            global $db_conn;

            $least_or_most = $_POST['coach_experience'];

            if ($least_or_most == 'least') {
                $result = executePlainSQL("SELECT nationality, MIN(years_of_experience) FROM Coach_C2 GROUP BY nationality");
            } else {
                $result = executePlainSQL("SELECT nationality, MAX(years_of_experience) FROM Coach_C2 GROUP BY nationality");
            }

            printTable($result);
        }

        function handleHavingRequest() {
            global $db_conn;

            $years_spent = $_POST['yearsSpent'];
            $entries = $_POST['entries'];

            $currentDate = new DateTime();
            $year = $currentDate->format("Y");

            $result = executePlainSQL("SELECT position, MIN(date_of_birth) AS date_of_birth FROM Player p, PlayerPlaysForTeam pt WHERE p.PID = pt.PID AND $year-pt.year_started >= $years_spent GROUP BY position HAVING COUNT(p.PID) >= $entries"); 
            printTable($result);
        }

        function handleNestedRequest() {
            global $db_conn;

            //$sqlstatement = executePlainSQL("SELECT tg.clubID, AVG(tg.goals) FROM teamPlaysInGame tg, GameIsInStage gs WHERE tg.GID = gs.GID AND tg.clubID = gs.clubID AND tg.team_name = gs.team_name GROUP BY tg.clubID HAVING AVG(tg.goals) <= all(SELECT AVG(g.goals_scored) FROM Game g, GameIsInStage gst WHERE g.GID = gst.GID  GROUP BY gst.SID)");
            $sqlstatement = executePlainSQL("SELECT DISTINCT g.GID, gis.SID, g.goals_scored FROM Game g, GameIsInStage gis WHERE g.GID = gis.GID AND g.goals_scored >= ALL(SELECT AVG(g2.goals_scored) FROM Game g2, GameIsInStage gis2 WHERE g2.GID = gis2.GID GROUP BY gis2.SID) ORDER BY gis.SID desc"); 


            printTable($sqlstatement);
        }

        // HANDLE ALL POST ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handlePOSTRequest() {
            if (connectToDB()) {
                if (array_key_exists('showTablesRequest', $_POST)) {
                    handleShowRequest();
                } else if (array_key_exists('havingQueryRequest', $_POST)) {
                    handleHavingRequest();
                } else if (array_key_exists('groupByQueryRequest', $_POST)) {
                    handleGroupByRequest();
                } else if (array_key_exists('nestedQueryRequest', $_POST)) {
                    handleNestedRequest();
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
                } else if (array_key_exists('showSubmit', $_GET)) {
                    handleShowRequest();
                } 

                disconnectFromDB();
            }
        }

		if (isset($_POST['havingSubmit']) || isset($_POST['groupBySubmit']) || isset($_POST['nestedSubmit'])) {
            handlePOSTRequest();
        } else if (isset($_GET['showTablesRequest'])) {
            handleGETRequest();
        }
		?>
	</body>
</html>
