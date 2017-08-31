class sql {
  mysql::db { 'test_mdb':
    user     => 'test_user',
    password => 'test',
    dbname   => 'test_mdb',
    grant    => ['SELECT', 'UPDATE'],
  }  
}

