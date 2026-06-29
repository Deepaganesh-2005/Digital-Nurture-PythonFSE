// ========================================================
// TASK 60
// Create Database
// ========================================================

use("college_nosql");


// ========================================================
// TASK 61
// Create Collection
// ========================================================

db.createCollection("feedback");


// ========================================================
// TASK 62
// Insert Sample Documents
// ========================================================

db.feedback.insertMany([

{
    student_id:1,
    course_code:"CS101",
    semester:"2022-ODD",
    rating:5,
    comments:"Excellent teaching and very informative.",
    tags:["challenging","well-structured","good-examples"],
    submitted_at:new Date("2022-11-30T10:15:00Z"),
    attachments:[
        {
            filename:"notes.pdf",
            size_kb:240
        }
    ]
},

{
    student_id:2,
    course_code:"CS101",
    semester:"2022-ODD",
    rating:4,
    comments:"Interesting subject.",
    tags:["challenging","interactive"],
    submitted_at:new Date(),
    attachments:[
        {
            filename:"assignment.pdf",
            size_kb:180
        }
    ]
},

{
    student_id:3,
    course_code:"CS101",
    semester:"2022-ODD",
    rating:3,
    comments:"Average experience.",
    tags:["good-examples"],
    submitted_at:new Date(),
    attachments:[
        {
            filename:"feedback.docx",
            size_kb:120
        }
    ]
},

{
    student_id:4,
    course_code:"CS102",
    semester:"2022-EVEN",
    rating:5,
    comments:"Loved the database concepts.",
    tags:["database","practical"],
    submitted_at:new Date(),
    attachments:[
        {
            filename:"db_notes.pdf",
            size_kb:300
        }
    ]
},

{
    student_id:5,
    course_code:"CS102",
    semester:"2022-EVEN",
    rating:2,
    comments:"Needs more practical sessions.",
    tags:["database","slow"],
    submitted_at:new Date(),
    attachments:[
        {
            filename:"review.pdf",
            size_kb:95
        }
    ]
},

{
    student_id:6,
    course_code:"CS103",
    semester:"2023-ODD",
    rating:4,
    comments:"Object Oriented concepts were clear.",
    tags:["oop","java"],
    submitted_at:new Date(),
    attachments:[
        {
            filename:"java.pdf",
            size_kb:160
        }
    ]
},

{
    student_id:7,
    course_code:"EC101",
    semester:"2023-ODD",
    rating:3,
    comments:"Circuit analysis was difficult.",
    tags:["electronics","challenging"],
    submitted_at:new Date(),
    attachments:[
        {
            filename:"circuits.pdf",
            size_kb:200
        }
    ]
},

{
    student_id:8,
    course_code:"ME101",
    semester:"2023-EVEN",
    rating:5,
    comments:"Excellent faculty support.",
    tags:["mechanical","practical"],
    submitted_at:new Date(),
    attachments:[
        {
            filename:"thermo.pdf",
            size_kb:170
        }
    ]
},

{
    student_id:9,
    course_code:"CS103",
    semester:"2022-ODD",
    rating:1,
    comments:"Very difficult subject.",
    tags:["oop","hard"],
    submitted_at:new Date(),
    attachments:[
        {
            filename:"issue.pdf",
            size_kb:130
        }
    ]
}

]);


// ========================================================
// TASK 63
// Insert Document without attachments
// ========================================================

db.feedback.insertOne(

{
    student_id:10,
    course_code:"CS101",
    semester:"2022-ODD",
    rating:4,
    comments:"Good explanation with examples.",
    tags:["good-examples","easy-understanding"],
    submitted_at:new Date()

}

);


// ========================================================
// TASK 64
// Verify Documents
// ========================================================

print("Total Documents:");

print(db.feedback.countDocuments());

print("\nAll Documents");

db.feedback.find();


// ========================================================
// Extra Verification
// ========================================================

print("\nCS101 Feedback");

db.feedback.find(
{
    course_code:"CS101"
});

print("\nFeedback Count");

db.feedback.countDocuments();

/*=========================================================
            TASK 2 : CRUD OPERATIONS
=========================================================*/


// ========================================================
// TASK 65
// Find all feedback with Rating = 5
// ========================================================

print("\nTASK 65 : Rating = 5");

db.feedback.find(
{
    rating:5
});



// ========================================================
// TASK 66
// Find CS101 feedback having "challenging" tag
// ========================================================

print("\nTASK 66 : CS101 + Challenging");

db.feedback.find(
{
    course_code:"CS101",
    tags:"challenging"
});



// ========================================================
// TASK 67
// Projection
// Display only student_id, course_code and rating
// ========================================================

print("\nTASK 67 : Projection");

db.feedback.find(
{},
{
    _id:0,
    student_id:1,
    course_code:1,
    rating:1
});



// ========================================================
// TASK 68
// Add needs_review=true where rating < 3
// ========================================================

print("\nTASK 68 : Update needs_review");

db.feedback.updateMany(

{
    rating:
    {
        $lt:3
    }
},

{
    $set:
    {
        needs_review:true
    }
}

);

print("Documents Updated Successfully.");



// ========================================================
// Verify Update
// ========================================================

db.feedback.find(
{
    needs_review:true
});



// ========================================================
// TASK 69
// Push "reviewed" into tags array
// ========================================================

print("\nTASK 69 : Push reviewed Tag");

db.feedback.updateMany(

{
    needs_review:true
},

{
    $push:
    {
        tags:"reviewed"
    }
}

);

print("Tags Updated Successfully.");



// ========================================================
// Verify Updated Tags
// ========================================================

db.feedback.find(
{
    needs_review:true
});



// ========================================================
// TASK 70
// Delete documents having semester = 2021-EVEN
// ========================================================

print("\nTASK 70 : Delete Documents");

db.feedback.deleteMany(

{
    semester:"2021-EVEN"
}

);

print("Deletion Completed.");



// ========================================================
// Verify Deletion
// ========================================================

db.feedback.find();

print("\nRemaining Documents");

print(db.feedback.countDocuments());



// ========================================================
// Additional CRUD Practice
// ========================================================

print("\nDocuments with Rating Greater Than 3");

db.feedback.find(
{
    rating:
    {
        $gt:3
    }
});



print("\nDocuments Needing Review");

db.feedback.find(
{
    needs_review:true
});



print("\nCS102 Feedback");

db.feedback.find(
{
    course_code:"CS102"
});



print("\nDatabase Status");

print("Feedback Count : " + db.feedback.countDocuments());


/*=========================================================
            TASK 3 : AGGREGATION PIPELINE
=========================================================*/


// ========================================================
// TASK 71
// Average Rating and Feedback Count
// ========================================================

print("\nTASK 71 : Average Rating by Course");

db.feedback.aggregate([

{
    $match:
    {
        semester:"2022-ODD"
    }
},

{
    $group:
    {
        _id:"$course_code",

        avg_rating:
        {
            $avg:"$rating"
        },

        total_feedback:
        {
            $sum:1
        }
    }
},

{
    $sort:
    {
        avg_rating:-1
    }
}

]);




// ========================================================
// TASK 72
// Rename Fields using $project
// ========================================================

print("\nTASK 72 : Project Stage");

db.feedback.aggregate([

{
    $match:
    {
        semester:"2022-ODD"
    }
},

{
    $group:
    {
        _id:"$course_code",

        avg_rating:
        {
            $avg:"$rating"
        },

        total_feedback:
        {
            $sum:1
        }
    }
},

{
    $project:
    {
        _id:0,

        course_code:"$_id",

        average_rating:
        {
            $round:["$avg_rating",1]
        },

        total_feedback:1
    }
},

{
    $sort:
    {
        average_rating:-1
    }
}

]);




// ========================================================
// TASK 73
// Tag Frequency using $unwind
// ========================================================

print("\nTASK 73 : Tag Frequency");

db.feedback.aggregate([

{
    $unwind:"$tags"
},

{
    $group:
    {
        _id:"$tags",

        total_occurrences:
        {
            $sum:1
        }
    }
},

{
    $sort:
    {
        total_occurrences:-1
    }
}

]);




// ========================================================
// TASK 74
// Create Index
// ========================================================

print("\nTASK 74 : Create Index");

db.feedback.createIndex(
{
    course_code:1
});




// ========================================================
// Verify Index
// ========================================================

db.feedback.find(
{
    course_code:"CS101"
}
).explain("executionStats");




// ========================================================
// Additional Verification
// ========================================================

print("\nDocuments for CS101");

db.feedback.find(
{
    course_code:"CS101"
});



print("\nRatings Greater Than 3");

db.feedback.find(
{
    rating:
    {
        $gt:3
    }
});



print("\nFeedback Count by Course");

db.feedback.aggregate([

{
    $group:
    {
        _id:"$course_code",

        total:
        {
            $sum:1
        }
    }
}

]);



print("\nTag Leaderboard");

db.feedback.aggregate([

{
    $unwind:"$tags"
},

{
    $group:
    {
        _id:"$tags",

        count:
        {
            $sum:1
        }
    }
},

{
    $sort:
    {
        count:-1
    }
}

]);



print("\nDatabase Summary");

print("Total Feedback Documents : "
+ db.feedback.countDocuments());



