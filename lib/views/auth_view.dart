import 'package:animated_visibility/animated_visibility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_chat/controllers/auth_controller.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Form(
                key: authController.formKey,
                child: Obx(
                  () => Column(
                    spacing: 14,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/stemmOne.png', width: 200),
                      SizedBox(height: 10),
                      // Email
                      TextFormField(
                        controller: authController.emailController,
                        validator: (val) {
                          return authController.emailValidator(val);
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Please enter your email address',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      // Password
                      TextFormField(
                        controller: authController.passwordController,
                        validator: (val) {
                          return authController.passwordValidator(val);
                        },
                        onFieldSubmitted: (_) {
                          if (!authController.isLogin.value) {
                            FocusScope.of(context).requestFocus(
                              authController.confirmPasswordFocusNode,
                            );
                          }
                        },
                        obscureText: !authController.isPasswordVisible.value,
                        textInputAction: authController.isLogin.value
                            ? TextInputAction.done
                            : TextInputAction.next,

                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'Please enter your password',
                          labelText: 'Password',

                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: authController.isPasswordVisible.toggle,
                            icon: Icon(
                              authController.isPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ),

                      // Confirm Password
                      AnimatedVisibility(
                        visible: !authController.isLogin.value,
                        enter: slideInVertically() + fadeIn(),
                        exit: slideOutVertically() + fadeOut(),
                        child: TextFormField(
                          controller: authController.confirmPasswordController,
                          validator: (val) {
                            return authController.confirmPasswordValidator(val);
                          },
                          focusNode: authController.confirmPasswordFocusNode,
                          obscureText:
                              !authController.isConfirmPasswordVisible.value,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Please confirm your password',
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: authController
                                  .isConfirmPasswordVisible
                                  .toggle,
                              icon: Icon(
                                authController.isConfirmPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(),
                      // Login/Signup button
                      SizedBox(
                        width: double.maxFinite,
                        height: 45,
                        child: FilledButton(
                          onPressed: authController.validateForm,
                          child: authController.isLoading.value
                              ? CupertinoActivityIndicator(color: Colors.white)
                              : Text(
                                  !authController.isLogin.value
                                      ? 'Signup'
                                      : 'Login',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      SizedBox(),
                      // Select auth type button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Text(
                            '${authController.isLogin.value ? 'Don\'t' : 'Already'} have an account?',
                            style: TextStyle(fontSize: 13),
                          ),
                          InkWell(
                            onTap: authController.isLogin.toggle,

                            child: Text(
                              authController.isLogin.value ? 'Signup' : 'Login',
                              style: TextStyle(
                                color: context.theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
