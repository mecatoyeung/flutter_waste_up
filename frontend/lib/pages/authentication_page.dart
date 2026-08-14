import 'package:flutter/material.dart';
import 'package:waste_up/l10n/app_localizations.dart';
import 'package:waste_up/theme/app_colors.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key, required this.isSignUp});

  final bool isSignUp;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool rememberMe = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showPreviewMessage(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  void switchMode() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AuthenticationPage(isSignUp: !widget.isSignUp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSignUp = widget.isSignUp;
    final title = isSignUp ? l10n.createAccount : l10n.welcomeBack;
    final subtitle = isSignUp ? l10n.signUpSubtitle : l10n.signInSubtitle;
    final actionLabel = isSignUp ? l10n.createAccount : l10n.signIn;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: 56,
                    height: 56,
                    color: yellow,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.recycling_outlined,
                      color: ink,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      height: 1.08,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(color: muted, height: 1.4),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    decoration: InputDecoration(
                      labelText: l10n.username,
                      hintText: l10n.usernameHint,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    textInputAction: isSignUp
                        ? TextInputAction.next
                        : TextInputAction.done,
                    autofillHints: isSignUp
                        ? const [AutofillHints.newPassword]
                        : const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: passwordVisible
                            ? l10n.hidePassword
                            : l10n.showPassword,
                        onPressed: () =>
                            setState(() => passwordVisible = !passwordVisible),
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  if (isSignUp) ...[
                    const SizedBox(height: 14),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: !confirmPasswordVisible,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: l10n.confirmPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: confirmPasswordVisible
                              ? l10n.hidePassword
                              : l10n.showPassword,
                          onPressed: () => setState(
                            () => confirmPasswordVisible =
                                !confirmPasswordVisible,
                          ),
                          icon: Icon(
                            confirmPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (!isSignUp) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) =>
                              setState(() => rememberMe = value ?? false),
                          activeColor: yellow,
                          checkColor: ink,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        Text(l10n.rememberMe),
                        const Spacer(),
                        TextButton(
                          onPressed: () =>
                              showPreviewMessage(l10n.featureComingSoon),
                          child: Text(l10n.forgotPassword),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: () =>
                          showPreviewMessage(l10n.authenticationPreview),
                      style: FilledButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: ink,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text(
                        actionLabel,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          l10n.orContinueWith,
                          style: const TextStyle(color: muted),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          showPreviewMessage(l10n.authenticationPreview),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ink,
                        side: const BorderSide(color: Color(0xFFDDE0DA)),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      icon: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                      label: Text(
                        l10n.continueWithGoogle,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isSignUp ? l10n.alreadyHaveAccount : l10n.newToWasteUp,
                        style: const TextStyle(color: muted),
                      ),
                      TextButton(
                        onPressed: switchMode,
                        child: Text(isSignUp ? l10n.signIn : l10n.signUp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
