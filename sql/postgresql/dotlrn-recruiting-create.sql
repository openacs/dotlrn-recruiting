--
--  Copyright (C) 2001, 2002 OpenForce
--
--  This file is part of this.
--
--  this is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  this is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- The recruiting applet for this
--
-- @author Ben Adida (ben@openforce.net)
-- @creation-date 2002-05-29
-- @version $Id$
--
-- ported to postgres by mohan pakkurti (mohan@pakkurti.com)
-- 2002-07-12
--

create function inline_0()
returns integer as '
declare
    foo                             integer;
begin

    foo := acs_sc_impl__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''dotlrn_recruiting''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''GetPrettyName'',
        ''dotlrn_recruiting::get_pretty_name'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''AddApplet'',
        ''dotlrn_recruiting::add_applet'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''RemoveApplet'',
        ''dotlrn_recruiting::remove_applet'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''AddAppletToCommunity'',
        ''dotlrn_recruiting::add_applet_to_community'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''RemoveAppletFromCommunity'',
        ''dotlrn_recruiting::remove_applet_from_community'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''AddUser'',
        ''dotlrn_recruiting::add_user'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''RemoveUser'',
        ''dotlrn_recruiting::remove_user'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''AddUserToCommunity'',
        ''dotlrn_recruiting::add_user_to_community'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''RemoveUserFromCommunity'',
        ''dotlrn_recruiting::remove_user_from_community'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''AddPortlet'',
        ''dotlrn_recruiting::add_portlet'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''RemovePortlet'',
        ''dotlrn_recruiting::remove_portlet'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''Clone'',
        ''dotlrn_recruiting::clone'',
        ''TCL''
    );

    foo := acs_sc_impl_alias__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting'',
        ''ChangeEventHandler'',
        ''dotlrn_recruiting::change_event_handler'',
        ''TCL''
    );

    perform acs_sc_binding__new (
        ''dotlrn_applet'',
        ''dotlrn_recruiting''
    );

    return 0;

end;' language 'plpgsql';

select inline_0();
drop function inline_0();
