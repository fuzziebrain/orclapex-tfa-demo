-- create tables
create table tfa_user (
    userid                         number not null constraint tfa_user_userid_pk primary key,
    username                       varchar2(50)
                                   constraint tfa_user_username_unq unique not null,
    password_hash                  varchar2(128) not null,
    shared_secret                  varchar2(16) not null,
    expiry_date                    date default SYSDATE + 90,
    active                         number(1) default '1'
                                   constraint tfa_user_active_bet
                                   check (active between 0 and 1) not null,
    tfa_enabled                    number(1) default '0'
                                   constraint tfa_user_tfa_enabled_bet
                                   check (tfa_enabled between 0 and 1) not null,
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;


-- triggers
create or replace trigger tfa_user_biu
    before insert or update
    on tfa_user
    for each row
begin
    if :new.userid is null then
        :new.userid := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
    if inserting then
        :new.created := sysdate;
        :new.created_by := nvl(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := nvl(sys_context('APEX$SESSION','APP_USER'),user);
end tfa_user_biu;
/