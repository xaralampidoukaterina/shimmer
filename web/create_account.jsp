<%-- 
    Created By Katerina Charalampidou 
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="index_css.css" type="text/css" /> 
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
        <title>Create Account</title>
    </head>
    <body class="body">
        <header class ="mainheader">
            <br>
            <center><div class="name"><h1>Shimmer Web Application</h1></div></center>
            <br>
            <%-- Create Navigation Bar --%>
            <nav class="navbar navbar-inverse">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <a class="navbar-brand" href="index.html">Shimmer Web App</a>
                    </div>
                    <div>
                        <ul class="nav navbar-nav">
                            <li><a href="index.html">Login Page</a></li>
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
                            <li class="active" ><a href="create_account.jsp"><span class="glyphicon glyphicon-user"></span>Sign Up</a></li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>
        <br>
        <!-- Create REGISTRATION FORM -->
        <div class="text-center" style="padding:50px 0">
            <div class="logo">Register</div>
            <!-- Main Form -->
            <div class="login-form-1">
                <%-- On Submit make password validation --%>
                <form id="register-form" class="text-left" action="create_account" name="account" onsubmit="return validateForm()" method="POST" accept-charset="UTF-8">
                    <div class="login-form-main-message"></div>
                    <div class="main-login-form">
                        <div class="login-group">
                            <div class="form-group">
                                <label for="reg_username" class="sr-only">Username</label>
                                <input type="text" class="form-control" id="reg_username" name="reg_username" placeholder="username">
                            </div>
                            <div class="form-group">
                                <label for="reg_password" class="sr-only">Password</label>
                                <input type="password" class="form-control" id="reg_password" name="reg_password" placeholder="password">
                            </div>
                            <div class="form-group">
                                <label for="reg_password_confirm" class="sr-only">Password Confirm</label>
                                <input type="password" class="form-control" id="reg_password_confirm" name="reg_password_confirm" placeholder="confirm password">
                            </div>
                        </div>
                        <button type="submit" class="login-button"><i class="fa fa-chevron-right"></i></button>
                    </div>
                    <%-- If you already have an account go to Login Page --%>
                    <div class="etc-login-form">
                        <p>Already have an account? <a href="index.html"><b> LOGIN HERE</b></a></p>
                    </div>
                </form>
            </div>
            <!-- end:Main Form -->
        </div>
        <script>
            function validateForm()
            {
                if (!(document.forms["account"]["reg_password_confirm"].value === document.forms["account"]["reg_password"].value))
                {
                    alert("The Password must be same with obove");
                    return false;
                }
            }
        </script>
    </body>
</html>
