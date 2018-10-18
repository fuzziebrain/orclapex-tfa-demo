create or replace package pkg_tfa_apex
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
  procedure p_register_user(
    p_username in varchar2
    , p_password in varchar2
    , p_confirm_password in varchar2
  );

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
  );

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
  ) return boolean;

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
  ) return boolean;

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
  ) return boolean;

end pkg_tfa_apex;
/