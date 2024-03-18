INSERT INTO public.ldap_servers VALUES (
    'localhost', 1, 'localhost', 1, 'default', 'ldap://127.0.0.1', 389, 0, 0, 3, '', NULL,
    'a:2:{i:0;s:27:\"ou=users,dc=yunohost,dc=org\";i:1;s:32:\"ou=permission,dc=yunohost,dc=org\";}',
    'uid', 'uid', 'mail', '', '', '', 0, 'cn=%username,ou=users,dc=yunohost,dc=org', '', '', '', 0,
    'permissionynh', 0, 1, 'permission', 'memberuid', 'dn', 0, '', '$app.main', '', 0, 1000, 0
);


INSERT INTO public.ldap_authorization VALUES (
    1, 'localhost', 'drupal_role', 'ldap_authorization_drupal_role', 1, 1, 0,
    'a:2:{i:0;a:6:{s:12:\"user_entered\";s:24:\"utilisateur authentifié\";s:4:\"from\";s:51:\"cn=framaforms.main,ou=permission,dc=yunohost,dc=org\";s:10:\"normalized\";s:24:\"utilisateur authentifié\";s:10:\"simplified\";s:24:\"utilisateur authentifié\";s:5:\"valid\";b:0;s:13:\"error_message\";s:112:\"Role <em class=\"placeholder\">utilisateur authentifié</em>_name does not exist and role creation is not enabled.\";}i:1;a:6:{s:12:\"user_entered\";s:13:\"administrator\";s:4:\"from\";s:52:\"cn=framaforms.admin,ou=permission,dc=yunohost,dc=org\";s:10:\"normalized\";s:13:\"administrator\";s:10:\"simplified\";s:13:\"administrator\";s:5:\"valid\";b:0;s:13:\"error_message\";s:101:\"Role <em class=\"placeholder\">administrator</em>_name does not exist and role creation is not enabled.\";}}',
    1, 0, 1, 1, 1, 1
);
