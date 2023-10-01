/* Note: This SQL queries are used inside DB2 cloud database */

/* list of school names, community names and average attendance 
for communities with a hardship index of 98 */

SELECT
    p.name_of_school,
    p.community_area_name,
    p.average_student_attendance
FROM public_school p
LEFT OUTER JOIN census_data c
ON p.community_area_number = c.community_area_number
WHERE c.hardship_index = 98;


/* list all crimes that took place at a school. Include case number, crime type and community name.*/
SELECT
    c.case_number,
    c.primary_type,
    cs.community_area_name
FROM crime_data c
LEFT OUTER JOIN census_data cs
ON cs.community_area_number = c.community_area_number
WHERE lower(c.location_description) LIKE 'schoo%';


/*  Accessing some data easily without storing a new table through view */
  CREATE VIEW chicago_school_rating (
  school_name, safety_rating, family_rating, environment_rating,
   instruction_rating, leaders_rating, teachers_rating
   ) AS 
        SELECT
            name_of_school,
            safety_icon,
            family_involvement_icon,
            environment_icon,
            instruction_icon,
            leaders_icon
        FROM public_school;

SELECT school_name, leaders_rating FROM chicago_school_rating;


/* Create stored procedure :
  This store procedure is written to make sure that when a score field is updated
  the icon field is updated too.
  It receives school id and a leaders score as input parameters, calculate the icon setting
  and updates the fiels accordingly */


  --#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE(
    IN in_school_id INTEGER, IN in_leader_score INTEGER)

LANGUAGE SQL
MOdIFIES SQL data

BEGIN

    UPDATE public_school
    SET leaders_score = in_leader_score
    WHERE school_id = in_school_id;

    IF in_leader_score BETWEEN 0 AND 19 THEN 
        UPDATE public_school
        SET leaders_icon = 'Very weak'
        WHERE school_id = in_school_id;

    ELSE IF in_leader_score < 40 THEN
        UPDATE public_school
        SET leaders_icon = 'Weak'
        WHERE school_id = in_school_id;

    ELSE IF in_leader_score < 60 THEN
        UPDATE public_school
        SET leaders_icon = 'Average'
        WHERE school_id = in_school_id;

    ELSE IF in_leader_score < 80 THEN
        UPDATE public_school
        SET leaders_icon = 'Strong'
        WHERE school_id = in_school_id;

    ELSE IF in_leader_score < 100 THEN
        UPDATE public_school
        SET leaders_icon = 'Very Strong'
        WHERE school_id = in_school_id;

    ELSE
        -- Roll back the current work for in_leader_score values
        -- outside the range (0, 100 included)
        ROLLBACK WORK;
    END IF

@


/* CALL PROCEDURE */
CALL UPDATE_LEADERS_SCORE (610320, 50)@
-- check with select school_id, leaders_score, leaders_icon from public_school where school_id = 610320



/* Put the procedure into a transaction (to avoid invalid data to modify our database) */
CREATE PROCEDURE UPDATE_LEADERS_SCORE(
    IN in_school_id INTEGER, IN in_leader_score INTEGER)

LANGUAGE SQL
MOdIFIES SQL data

BEGIN

    UPDATE public_school
    SET leaders_score = in_leader_score
    WHERE school_id = in_school_id;

    IF in_leader_score BETWEEN 0 AND 19 THEN 
        UPDATE public_school
        SET leaders_icon = 'Very weak'
        WHERE school_id = in_school_id;

    ELSE IF in_leader_score < 40 THEN
        UPDATE public_school
        SET leaders_icon = 'Weak'
        WHERE school_id = in_school_id;

    ELSE IF in_leader_score < 60 THEN
        UPDATE public_school
        SET leaders_icon = 'Average'
        WHERE school_id = in_school_id;

    ELSE IF in_leader_score < 80 THEN
        UPDATE public_school
        SET leaders_icon = 'Strong'
        WHERE school_id = in_school_id;

    ELSE IF in_leader_score < 100 THEN
        UPDATE public_school
        SET leaders_icon = 'Very Strong'
        WHERE school_id = in_school_id;

    ELSE
        -- Roll back the current work for in_leader_score values
        -- outside the range (0, 100 included)
        ROLLBACK WORK;
    END IF

        -- Commit the current unit of work
    COMMIT  

END
@






