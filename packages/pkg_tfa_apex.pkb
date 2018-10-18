create or replace package body pkg_tfa_apex
as
  /**
   * TODO_Comments
   *
   * Notes:
   *  -
   *
   * Related Tickets:
   *  -
   *
   * @author TODO
   * @created TODO
   * @param TODO
   * @return TODO
   */
  --
  function f_hash_password(
    p_password varchar2
  ) return varchar2
  as
  begin
    return
      oos_util_crypto.hash_str(
        p_src => p_password
        , p_typ => oos_util_crypto.gc_hash_sh256
      )
    ;
  end f_hash_password;

  /**
   * TODO_Comments
   *
   * Notes:
   *  -
   *
   * Related Tickets:
   *  -
   *
   * @author TODO
   * @created TODO
   * @param TODO
   * @return TODO
   */
  --
  procedure p_register_user(
    p_username in varchar2
    , p_password in varchar2
    , p_confirm_password in varchar2
  )
  as
    l_shared_secret tfa_user.shared_secret%type;
    l_password_hash tfa_user.password_hash%type;
    l_num_results pls_integer := -1;

    illegal_arguments_error exception;
  begin
    if
        p_username is null
        or p_password is null
        or p_password != p_confirm_password
    then
      raise illegal_arguments_error;
    end if;

    l_password_hash := f_hash_password(p_password => p_password);

    while l_num_results != 0
    loop
      l_shared_secret := oos_util_totp.generate_secret;

      select count(1)
      into l_num_results
      from tfa_user
      where shared_secret = l_shared_secret;
    end loop;

    insert into tfa_user
    (
      username
      , password_hash
      , shared_secret
    )
    values
    (
      p_username
      , l_password_hash
      , l_shared_secret
    );
  exception
    when others then
      -- error handling
      raise;
  end p_register_user;

  /**
   * TODO_Comments
   *
   * Notes:
   *  -
   *
   * Related Tickets:
   *  -
   *
   * @author TODO
   * @created TODO
   * @param TODO
   * @return TODO
   */
  --
  procedure p_authenticate_user(
    p_username in varchar2
    , p_password in varchar2
  )
  as
    l_password_hash tfa_user.password_hash%type;
    l_tfa_enabled tfa_user.tfa_enabled%type;

    login_failed exception;
  begin
    begin
      select password_hash, tfa_enabled
      into l_password_hash, l_tfa_enabled
      from tfa_user
      where 1 = 1
        and lower(username) = lower(p_username)
        and coalesce(expiry_date, sysdate) >= sysdate
        and active = 1
      ;
    exception
      when no_data_found then
        raise login_failed;
    end;

    if l_password_hash = f_hash_password(p_password => p_password) then
      if l_tfa_enabled = 0 then
        apex_authentication.post_login(
          p_username => p_username
          , p_password => null
        );
        apex_util.clear_page_cache();
      end if;
    else
      raise login_failed;
    end if;
  exception
    when login_failed then
      apex_authentication.login(
        p_username => p_username
        , p_password => null
      );
  end p_authenticate_user;

  /**
   * TODO_Comments
   *
   * Notes:
   *  -
   *
   * Related Tickets:
   *  -
   *
   * @author TODO
   * @created TODO
   * @param TODO
   * @return TODO
   */
  --
  function f_authenticate_user(
    p_username in varchar2
    , p_password in varchar2
  ) return boolean
  as
    l_password_hash tfa_user.password_hash%type;
  begin
    select password_hash
    into l_password_hash
    from tfa_user
    where 1 = 1
      and lower(username) = lower(p_username)
      and coalesce(expiry_date, sysdate) >= sysdate
      and active = 1
    ;

    return l_password_hash = f_hash_password(p_password => p_password);
  exception
    when no_data_found then
      return false;
  end f_authenticate_user;

  /**
   * TODO_Comments
   *
   * Notes:
   *  -
   *
   * Related Tickets:
   *  -
   *
   * @author TODO
   * @created TODO
   * @param TODO
   * @return TODO
   */
  --
  function f_validate_otp(
    p_userid in tfa_user.userid%type
    , p_otp in number
  ) return boolean
  as
    l_shared_secret tfa_user.shared_secret%type;
  begin
    select shared_secret
    into l_shared_secret
    from tfa_user
    where 1 = 1
      and userid = p_userid
      and coalesce(expiry_date, sysdate) >= sysdate
      and active = 1
    ;

    return
      oos_util_totp.validate_otp(
        p_secret => l_shared_secret
        , p_otp => p_otp
      ) = 1
    ;
  exception
    when no_data_found then
      return false;
  end f_validate_otp;

  /**
   * TODO_Comments
   *
   * Notes:
   *  -
   *
   * Related Tickets:
   *  -
   *
   * @author TODO
   * @created TODO
   * @param TODO
   * @return TODO
   */
  --
  function f_validate_otp(
    p_username in tfa_user.username%type
    , p_otp in number
  ) return boolean
  as
    l_userid tfa_user.userid%type;
  begin
    select userid
    into l_userid
    from tfa_user
    where lower(username) = lower(p_username);

    return f_validate_otp(p_userid => l_userid, p_otp => p_otp);
  exception
    when no_data_found then
      return false;
  end f_validate_otp;
end pkg_tfa_apex;
/