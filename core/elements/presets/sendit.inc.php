<?php

return [
    'user' => [
        'hooks' => '',
        'snippet' => '@FILE snippets/manage_users.php',
    ],
    'find_user' => [
        'extends' => 'user',
        'method' => 'findUser',
    ],
    'remove_user' => [
        'extends' => 'user',
        'method' => 'removeUser',
    ],
    'manage_user' => [
        'clearFieldsOnSuccess' => 1,
        'extends' => 'manage_users',
        'method' => 'manageUser',
        'successMessage' => 'Пользователь добавлен.',
        'validate' => 'fullname:required,email:required,phone:required',
    ],
];
