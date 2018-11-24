{$IFDEF VER80}
  {$DEFINE Delphi1}
  {$DEFINE Delphi1up}
{$ELSE}
  {$IFDEF VER90}
    {$DEFINE Delphi2}
    {$DEFINE Delphi2up}
  {$ELSE}
    {$IFDEF VER100}
      {$DEFINE Delphi3}
      {$DEFINE Delphi3up}
    {$ELSE}
      {$IFDEF VER120}
        {$DEFINE Delphi4}
        {$DEFINE Delphi4up}
      {$ELSE}
        {$IFDEF VER130}
          {$DEFINE Delphi5}
          {$DEFINE Delphi5up}
        {$ELSE}
          {$IFDEF VER140}
            {$DEFINE Delphi6}
            {$DEFINE Delphi6up}
          {$ELSE}
            {$IFDEF VER150}
              {$DEFINE Delphi7}
              {$DEFINE Delphi7up}
            {$ELSE}
              {$IFDEF VER170}
                {$DEFINE Delphi2005}
                {$DEFINE Delphi2005up}
              {$ELSE}
                {$IFDEF VER180}
                  {$DEFINE Delphi2006}
                  {$DEFINE Delphi2006up}
                {$ELSE}
                  {$IFDEF VER190}
                    {$DEFINE Delphi2007}
                    {$DEFINE Delphi2007up}
                  {$ELSE}
                    {$IFDEF VER200}
                      {$DEFINE Delphi2009}
                      {$DEFINE Delphi2009up}
                    {$ELSE}
                      {$IFDEF VER210}
                        {$DEFINE Delphi2010}
                        {$DEFINE Delphi2010up}
                      {$ELSE}
                        {$IFDEF VER220}
                          {$DEFINE DelphiXE}
                          {$DEFINE DelphiXEup}
                        {$ELSE}
                          {$IFDEF VER230}
                            {$DEFINE DelphiXE2}
                            {$DEFINE DelphiXE2up}
                          {$ELSE}
                            {$IFDEF VER240}
                              {$DEFINE DelphiXE3}
                              {$DEFINE DelphiXE3up}
                            {$ELSE}
                              {$IFDEF VER250}
                                {$DEFINE DelphiXE4}
                                {$DEFINE DelphiXE4up}
                              {$ELSE}
                                {$IFDEF VER260}
                                  {$DEFINE DelphiXE5}
                                  {$DEFINE DelphiXE5up}
                                {$ELSE}
                                  {$IFDEF VER270}
                                    {$DEFINE DelphiXE6}
                                    {$DEFINE DelphiXE6up}
                                  {$ELSE}
                                    {$IFDEF VER280}
                                      {$DEFINE DelphiXE7}
                                      {$DEFINE DelphiXE7up}
                                    {$ELSE}
                                      {$IFDEF VER290}
                                        {$DEFINE DelphiXE8}
                                        {$DEFINE DelphiXE8up}
                                      {$ELSE}
                                        {$IFDEF VER300}
                                          {$DEFINE Delphi10Seattle}
                                          {$DEFINE Delphi10SeattleUp}
                                        {$ELSE}
                                          {$IFDEF VER310}
                                            {$DEFINE Delphi10Berlin}
                                            {$DEFINE Delphi10BerlinUp}
                                          {$ELSE}
                                            {$IFDEF VER320}
                                              {$DEFINE Delphi10Tokyo}
                                              {$DEFINE Delphi10TokyoUp}
                                            {$ELSE}
                                              {$IFDEF VER330}
                                                {$DEFINE Delphi10Rio}
                                              {$ENDIF}
                                              {$DEFINE Delphi10RioUp}
                                            {$ENDIF}
                                          {$ENDIF}
                                        {$ENDIF}
                                      {$ENDIF}
                                    {$ENDIF}
                                  {$ENDIF}
                                {$ENDIF}
                              {$ENDIF}
                            {$ENDIF}
                          {$ENDIF}
                        {$ENDIF}
                      {$ENDIF}
                    {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF Delphi10Rio}
{$DEFINE Delphi10_3}
{$ENDIF}
{$IFDEF Delphi10Tokyo}
{$DEFINE Delphi10_2}
{$ENDIF}
{$IFDEF Delphi10Berlin}
{$DEFINE Delphi10_1}
{$ENDIF}
{$IFDEF Delphi10Seattle}
{$DEFINE Delphi10_0}
{$ENDIF}

{$IFDEF Delphi10RioUp}
{$DEFINE Delphi10_3Up}
{$DEFINE Delphi10TokyoUp}
{$ENDIF}
{$IFDEF Delphi10TokyoUp}
{$DEFINE Delphi10_2Up}
{$DEFINE Delphi10BerlinUp}
{$ENDIF}
{$IFDEF Delphi10BerlinUp}
{$DEFINE Delphi10_1Up}
{$DEFINE Delphi10SeattleUp}
{$ENDIF}
{$IFDEF Delphi10SeattleUp}
{$DEFINE Delphi10_0Up}
{$DEFINE DelphiXE8up}
{$ENDIF}
{$IFDEF DelphiXE8up}
{$DEFINE DelphiXE7up}
{$ENDIF}
{$IFDEF DelphiXE7up}
{$DEFINE DelphiXE6up}
{$ENDIF}
{$IFDEF DelphiXE6up}
{$DEFINE DelphiXE5up}
{$ENDIF}
{$IFDEF DelphiXE5up}
{$DEFINE DelphiXE4up}
{$ENDIF}
{$IFDEF DelphiXE4up}
{$DEFINE DelphiXE3up}
{$ENDIF}
{$IFDEF DelphiXE3up}
{$DEFINE DelphiXE2up}
{$ENDIF}
{$IFDEF DelphiXE2up}
{$DEFINE DelphiXEup}
{$ENDIF}
{$IFDEF DelphiXEup}
{$DEFINE Delphi2010up}
{$ENDIF}
{$IFDEF Delphi2010up}
{$DEFINE Delphi2009up}
{$ENDIF}
{$IFDEF Delphi2009up}
{$DEFINE Delphi2007up}
{$ENDIF}
{$IFDEF Delphi2007up}
{$DEFINE Delphi2006up}
{$ENDIF}
{$IFDEF Delphi2006up}
{$DEFINE Delphi2005up}
{$ENDIF}
{$IFDEF Delphi2005up}
{$DEFINE Delphi7up}
{$ENDIF}
{$IFDEF Delphi7up}
{$DEFINE Delphi6up}
{$ENDIF}
{$IFDEF Delphi6up}
{$DEFINE Delphi5up}
{$ENDIF}
{$IFDEF Delphi5up}
{$DEFINE Delphi4up}
{$ENDIF}
{$IFDEF Delphi4up}
{$DEFINE Delphi3up}
{$ENDIF}
{$IFDEF Delphi3up}
{$DEFINE Delphi2up}
{$ENDIF}
{$IFDEF Delphi2up}
{$DEFINE Delphi1up}
{$ENDIF}

