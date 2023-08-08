<!-- Aggregations queries. 
    Based on the oracle-test.php:
        Test Oracle file for UBC CPSC304 2018 Winter Term 1
        Created by Jiemin Zhang
        Modified by Simona Radu
        Modified by Jessica Wong (2018-06-22) -->
<!DOCTYPE html>
<html>
    <head>
        <title>Aggregations</title>
        <link href="styles.css" type="text/css" rel="stylesheet"> 
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter&family=Open+Sans:wght@300&display=swap" rel="stylesheet">
    </head>

    <body>
        <h2>Here you can find some information about coaches, players, and games</h2>
        <hr />
        <div class = "show">
        <h2>Show a table</h2>
        <p>If you wish to see a table, choose a name and press on the show button 

        <form method="GET" action="aggregations.php">
            <input type="hidden" id="showTablesRequest" name="showTablesRequest">
            Name: <select name="tName"> 
                    <option>Coach</option>
                    <option>Player and team</option>
                    <option>Game and stage</option>
                  </select> 
            <input type="submit" value="Show" name="showSubmit">
        </form> </p>
        </div>

        <hr />

        <div class = "queries">
        <div class = "coaches">
        <h2>Coaches</h2>
        <form method="POST" action="aggregations.php"> 
            <input type="hidden" id="groupByQueryRequest" name="groupByQueryRequest">
            <p>Find years of experience of the 
            <select name="coach_experience">
                <option>least</option>
                <option>most</option>
            </select> experienced coaches of each nationality</p> 
            <input type="submit" value="Submit" name="groupBySubmit"></p>
        </form>
        </div>

        <hr />

        <div class = "players">
        <h2>Players</h2>

        <form method="POST" action="aggregations.php"> 
            <input type="hidden" id="havingQueryRequest" name="havingQueryRequest">
            <p>Find dates of birth of the oldest players who have spent more than <input type="number" name="yearsSpent" style="width: 50px"> years at their club, for each position with at least <input type="number" name = "entries" style="width: 50px"> such entries </p>
            <input type="submit" value="Submit" name="havingSubmit"></p>
        </form>
        </div>

        <hr />

        <div class = "games">
        <h2>Games</h2>
        <form method="POST" action="aggregations.php"> 
            <p>Find the games with more scored goals than the average in each stage of the tournament</p> 
            <input type="hidden" id="nestedQueryRequest" name="nestedQueryRequest">
            <input type="submit" value="Submit" name="nestedSubmit"></p>
        </form>
        </div>
        </div>

        <?php 

        $success = True; 
        $db_conn = NULL; 
        $show_debug_alert_messages = False; 

        function debugAlertMessage($message) {
            global $show_debug_alert_messages;

            if ($show_debug_alert_messages) {
                echo "<script type='text/javascript'>alert('" . $message . "');</script>";
            }
        }

        function executePlainSQL($cmdstr) { 
            global $db_conn, $success;

            $statement = OCIParse($db_conn, $cmdstr);

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn); 
                echo htmlentities($e['message']);
                $success = False;
            }

            $r = OCIExecute($statement, OCI_DEFAULT);
            if (!$r) {
                echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                $e = oci_error($statement); 
                echo htmlentities($e['message']);
                $success = False;
            }

			return $statement;
		}

        function executeBoundSQL($cmdstr, $list) {
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
                    OCIBindByName($statement, $bind, $val);
                    unset ($val); 
				}

                $r = OCIExecute($statement, OCI_DEFAULT);
                if (!$r) {
                    echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                    $e = OCI_Error($statement); 
                    echo htmlentities($e['message']);
                    echo "<br>";
                    $success = False;
                }
            }
        }

        function printTable($result) { //prints the statement
            $ncols = oci_num_fields($result);

            echo "<br>Retrieved data: <br> <p> </p>";
            echo "<table align='center'>";

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

            $db_conn = OCILogon("ora_diakel", "a95044343", "dbhost.students.cs.ubc.ca:1522/stu");

            if ($db_conn) {
                debugAlertMessage("Database is Connected");
                return true;
            } else {
                debugAlertMessage("Cannot connect to Database");
                $e = OCI_Error(); 
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
                $result = executePlainSQL("SELECT nationality, MIN(years_of_experience) AS Years_of_experience FROM Coach_C2 GROUP BY nationality");
            } else {
                $result = executePlainSQL("SELECT nationality, MAX(years_of_experience) AS Years_of_experience FROM Coach_C2 GROUP BY nationality");
            }

            printTable($result);
        }

        function handleHavingRequest() {
            global $db_conn;

            $years_spent = $_POST['yearsSpent'];
            $entries = $_POST['entries'];

            if (!$years_spent || !$entries) {
                echo "Please, enter some number in the fields";
            } else {
                $currentDate = new DateTime();
                $year = $currentDate->format("Y");

                $result = executePlainSQL("SELECT position, MIN(date_of_birth) AS date_of_birth FROM Player p, PlayerPlaysForTeam pt WHERE p.PID = pt.PID AND $year-pt.year_started >= $years_spent GROUP BY position HAVING COUNT(p.PID) >= $entries"); 
                printTable($result);
            }
        }

        function handleNestedRequest() {
            global $db_conn;

            $temp = executePlainSQL("CREATE VIEW AvgGoalsPerStage(SID, goals_scored) AS SELECT gis2.SID, AVG(g2.goals_scored) FROM Game g2, GameIsInStage gis2 WHERE g2.GID = gis2.GID GROUP BY gis2.SID");

            $sqlstatement = executePlainSQL("SELECT DISTINCT g.GID, gis.SID, g.goals_scored FROM Game g, GameIsInStage gis WHERE g.GID = gis.GID AND g.goals_scored >= ALL(SELECT goals_scored FROM AvgGoalsPerStage) ORDER BY gis.SID desc"); 

            printTable($sqlstatement);
            executePlainSQL("DROP VIEW AvgGoalsPerStage");
        }

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

        function handleGETRequest() {
            if (connectToDB()) {
                if (array_key_exists('showSubmit', $_GET)) {
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
