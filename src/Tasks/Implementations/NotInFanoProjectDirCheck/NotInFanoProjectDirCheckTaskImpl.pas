(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit NotInFanoProjectDirCheckTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    InFanoProjectDirCheckTaskImpl;

type

    (*!--------------------------------------
     * Task that run other task only if
     * we are not in project directory that is generated
     * by Fano CLI tools. This is inverse of TInFanoProjectDirCheckTask
     *------------------------------------------
     * This is to protect accidentally creating project
     * inside Fano-CLI generated project directory
     * structure.
     *--------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TNotInFanoProjectDirCheckTask = class(TInFanoProjectDirCheckTask)
    public
        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask; override;
    end;

implementation

uses

    SysUtils;

resourcestring
    sFanoDir = 'Current directory was generated by Fano CLI. ' +
               'Maybe you should not use any --project-* command here.';
    sRunWithHelp = 'Run with --help option to view available task.';

    function TNotInFanoProjectDirCheckTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    begin
        if (not inFanoCliGeneratedProjectDir(getCurrentDir() + DirectorySeparator)) then
        begin
            actualTask.run(opt, longOpt);
        end else
        begin
            writeln(sFanoDir);
            writeln(sRunWithHelp);
        end;
        result := self;
    end;
end.
